###*
 * watch internal architecture
 * _WatchListeners=
 * 		eventNativeName:[
 * 			force: boolean,
 * 			selectorFx,
 *			passive: boolean,
 * 			listener: function,
 * 			eventName,
 * 			eventGrp
 * 		]
###
_WatchListeners = _create null
_WatchMainListeners = _create null
_watchSpecialEvents = _create null
_watchSpecialEventsWrapper = _create null
_mapListeners = new WeakMap()
_WatchListenersStep = 6
_checkEventName = /^[a-z_-]+(?:\.[a-z._-]+)?$/
_checkEventRegex= /^[a-z_-]+$/


# add special watch events
#=include watch-special.coffee
#=include event-*.coffee


### watch events ###
_defineProperties Reactor,
	###*
	 * Remove event listeners
	###
	# off: (selector, )
	###*
	 * @param  {string or function} selector - selector to match element
	 * @param  {}
	 * @return {[type]}
	###
	watch: value: (selector, events)->
		throw new Error "Illegal arguments" unless arguments.length is 2
		throw new Error "Selector expected string" unless typeof selector is 'string' # or typeof selector is 'function'
		throw new Error "Illegal events" unless typeof events is 'object' and events
		# fix selector
		# if typeof selector is 'string'
		# 	cssSelector = selector
		# 	selector = (obj)-> obj.matches cssSelector
		# else unless typeof selector is 'function'
		# 	throw new Error "selector expected string or function"
		# add events
		for eventName, eventValue of events
			# process event name
			eventName = eventName.toLowerCase()
			throw new Error "Event name must match: #{_checkEventName.toString()}. ie: {eventName} or {eventName.appId} or {eventName.appId.grpId...}. " unless _checkEventName.test eventName
			i = eventName.indexOf '.'
			if i is -1
				eventGrp = null
			else
				eventGrp = eventName.substr i + 1
				eventName= eventName.substr 0, i
			# options
			if typeof eventValue is 'function'
				eventValue=
					passive: no
					force: off
					listener: eventValue
			else
				throw new Error "Event descriptor expected object" unless typeof eventValue is 'object' and eventValue
				throw new Error "Listener required" unless 'listener' of eventValue
				throw new Error "Listener expected function" unless typeof eventValue.listener is 'function'
			# when special event
			evSpecial = _watchSpecialEvents[eventName]
			if evSpecial
				nativeEventName = evSpecial[<%= watchSpecialEvents.nativeEvent %>]
				orListener = eventValue.listener # original listener
				eventValue.listener = listener = evSpecial[<%= watchSpecialEvents.listener %>] orListener
				throw new Error "Expected function as listener" unless typeof listener is 'function'
				_mapListeners.set orListener, listener
			else
				nativeEventName = eventName
			# nativeEventName = _watchSpecialEvents[eventName]?[<%= watchSpecialEvents.nativeEvent %>] || eventName
			# else: native event
			_watchRegisterNativeEvent eventName, nativeEventName, eventGrp, eventValue, selector
		# chain
		return this
	###*
	 * Remove event listeners
	 * @param  {[type]} selector [description]
	 * @param  {[type]} events   [description]
	 *
	 * @example
	 * Reactor.unwatch('selector') # remove all listeners on this selector
	 * Reactor.unwatch('selector', {click: true, dblclick: true}) # remove all click and dblclick listeners
	 * Reactor.unwatch('selector', {click: fx}) # remove "fx" listener on click event 
	###
	unwatch: value: (selector, events)->
		throw new Error 'Selector expected string' unless typeof selector is 'string'
		switch arguments.length
			# remove specific events
			when 2
				throw new Error "Illegal event descriptor" unless typeof events is 'object' and events
				for eventName, eventValue of events
					# process event name
					eventName = eventName.toLowerCase()
					throw new Error "Illegal event name" unless _checkEventName.test eventName
					i = eventName.indexOf '.'
					if i is -1
						eventGrp = null
					else
						eventGrp = eventName.substr i + 1
						eventName= eventName.substr 0, i
					# get listener
					eventValue = eventValue.listener if typeof eventValue is 'object' and eventValue
					# remover
					op = [(evSelector, evListener, evName, evGrp)-> evSelector is selector and evName is eventName]
					# remove specific listener
					if typeof eventValue is 'function'
						# map listener
						eventValue = _mapListeners.get eventValue if _mapListeners.has eventValue
						# check for listener
						op.push (evSelector, evListener, evName, evGrp)-> evListener is eventValue
					# specific group
					if eventGrp
						eventGrpDot = evGrp + '.'
						op.push (evSelector, evListener, evName, evGrp)->
							if evGrp
								evGrp is eventGrp or eventGrp.startsWith eventGrpDot
					# native event
					nativeEventName = _watchSpecialEvents[eventName]?[<%= watchSpecialEvents.nativeEvent %>] || eventName
					# check and remove
					_unwatchRm nativeEventName, (evSelector, evListener, evName, evGrp)->
						# we did'nt use "Array::every" method for performance purpose
						for fx in op
							return false unless fx evSelector, evListener, evName, evGrp
						return true
			# remove all events
			when 1
				for eventName of _WatchListeners
					_unwatchRm eventName, (evSelector, evListener, evName, evGrp)-> evSelector is selector
			# error
			else
				throw new Error 'Illegal arguments'
			#TODO remove event listener when all events are removed
		# chain
		this

###*
 * Register native event
###
_watchRegisterNativeEvent = (eventName, nativeEventName, eventGrp, eventValue, selector)->
	ev = _WatchListeners[nativeEventName]
	# already set event
	if ev
		ev.push !!eventValue.force, selector, !!eventValue.passive, eventValue.listener, eventName, eventGrp
	# register new Event
	else 
		_WatchListeners[nativeEventName]= [!!eventValue.force, selector, !!eventValue.passive, eventValue.listener, eventName, eventGrp]
		# register the event on the DOM
		_registerWatchEvent nativeEventName
	return

###*
 * Register the event on the DOM
###
_registerWatchEvent = (eventName)->
	throw new Error "Listener already set" if _WatchMainListeners[eventName]
	listener = _WatchMainListeners[eventName] = (event)-> _watchEventExec event, eventName
	window.addEventListener eventName, listener, true

_watchEventExec = (event, eventName) ->
	# event path
	eventPath = event.path
	unless eventPath
		eventPath = event.path = _targetPathGen event.target
	# get registered listeners
	ev = _WatchListeners[eventName]
	return unless ev
	# loop over elements
	bubbles = event.bubbles
	for ele in event.path
		break if ele is document
		# wrap event
		eventClss = _watchSpecialEventsWrapper[eventName]
		unless eventClss
			eventClss = EventWrapper
		evnt = new eventClss event, ele, bubbles
		# exec all listeners
		bubbles = _triggerEvent ele, ev, evnt, bubbles
	return
_triggerEvent = (ele, queue, event, bubbles)->
	i = 0
	len = queue.length
	doBubbles = bubbles
	execBubble = bubbles || ele is event.target
	while i < len
		# continue if no force and propagation stoped
		force	= queue[i]
		unless execBubble or force
			i += _WatchListenersStep
			continue
		# selector
		selector = queue[++i]
		# unless selector ele
		unless ele.matches selector
			i += 5 # passive, listener, eventName, eventGrp
			continue 
		# is passive
		passive = queue[++i]
		listener= queue[++i]
		i+= 3 # eventName, eventGrp
		# exec listener
		if passive
			do (listener)->
				setTimeout (->
					try
						listener.call ele, event
					catch err
						Reactor.error 'UNCAUGHT_ERROR>>', err
				), 0
		else
			try
				listener.call ele, event
			catch err
				Reactor.error 'UNCAUGHT_ERROR>>', err
			# bubbles
			doBubbles = off if event.bubbles is off
			bubbles = off if event.bubblesImmediate is off
	return doBubbles

###*
 * remove watch
###
_unwatchRm = (eventNativeName, checkCb)->
	eventQ = _WatchListeners[eventNativeName]
	return unless eventQ
	# seeking
	i = 0
	len = eventQ.length
	while i < len
		# load data from Queue
		j = i
		force		= eventQ[j]
		evSelector	= eventQ[++j]
		passive		= eventQ[++j]
		evListener	= eventQ[++j]
		evName		= eventQ[++j]
		evGrp		= eventQ[++j]
		++j
		# check
		unless checkCb evSelector, evListener, evName, evGrp
			i = j
			continue
		# remove
		eventQ.splice i, _WatchListenersStep
	# remove main listener when no more listeners
	unless eventQ.length
		delete _WatchListeners[eventNativeName]
		window.removeEventListener eventNativeName, _WatchMainListeners[eventNativeName], true
		eventNativeName[eventNativeName] = null
	return

###*
 * trigger self event
###
_triggerSelf = (ele, eventName, event)->
	ev = _WatchListeners[eventName]
	return unless ev
	_triggerEvent ele, ev, event, true
	return