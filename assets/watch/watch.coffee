###*
 * watch internal architecture
 * _WatchListeners=
 * 		eventName:[
 * 			force: boolean,
 * 			selectorFx,
 *			passive: boolean,
 * 			listener: function
 * 		]
###
_WatchListeners = _create null
_WatchListenersStep = 4


# add special watch events
#=include watch-special.coffee


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
			eventName = eventName.toLowerCase()
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
			if eventName of _watchSpecialEvents
				_watchSpecialEvents[eventName].add selector, eventValue
			# else: native event
			else
				_watchRegisterNativeEvent eventName, eventValue, selector
		return

###*
 * Register native event
###
_watchRegisterNativeEvent = (eventName, eventValue, selector)->
	ev = _WatchListeners[eventName]
	# already set event
	if ev
		ev.push !!eventValue.force, selector, !!eventValue.passive, eventValue.listener
	# register new Event
	else 
		_WatchListeners[eventName]= [!!eventValue.force, selector, !!eventValue.passive, eventValue.listener]
		# register the event on the DOM
		_registerWatchEvent eventName

###*
 * Register the event on the DOM
###
_registerWatchEvent = (eventName)->
	window.addEventListener eventName, ( (event)-> _watchEventExec event, eventName ), true

_watchEventExec = (event, eventName) ->
	# get registered listeners
	ev = _WatchListeners[eventName]
	return unless ev
	len= ev.length
	# loop over elements
	bubbles = event.bubbles
	for ele in event.path
		break if ele is document
		# exec all listeners
		i =0
		while i < len
			# continue if no force and propagation stoped
			force	= ev[i]
			unless bubbles or force
				i += _WatchListenersStep
				continue
			# selector
			selector = ev[++i]
			# unless selector ele
			unless ele.matches selector
				i += 3 # passive, listener
				continue 
			# is passive
			passive = ev[++i]
			listener= ev[++i]
			++i
			# exec listener
			if passive
				setTimeout (-> listener.call ele, new EventWrapper event, ele, bubbles), 0
			else
				evnt = new EventWrapper event, ele, bubbles
				listener.call ele, evnt
				bubbles = evnt.bubbles
	return
