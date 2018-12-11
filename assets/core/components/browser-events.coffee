###*
 * @private
 * define browser events
 * @param {string} eventName - uppercased event name
###
_browserListeners = _create null
_mapListeners	  = 
_defineBrowserEvent = (eventName)->
	throw new Error "Event [#{eventName}] already set" if _browserListeners[eventName]
	evSpecial = _watchSpecialEvents[eventName]
	if evSpecial
		listener = _defineBrowserSpecialEvents eventName, evSpecial[<%= watchSpecialEvents.nativeEvent %>], evSpecial[<%= watchSpecialEvents.listener %>]
	else
		listener = _defineBrowserBublleEvent eventName
	_browserListeners[eventName] = listener
	window.addEventListener eventName, listener, true
	return
###*
 * Browser normal events
###
_defineBrowserBublleEvent = (eventName)->
	(event)->
		eventAttrName = ':' + eventName
		# get path
		target = event.target
		targetIndx = 0
		eventPath = event.path || _targetPathGen target
		# seek
		for ele,k in eventPath
			# seek for component
			tagName = ele.tagName.toUpperCase()
			componentDescriptor = _components[tagName]
			continue unless componentDescriptor
			component = _data(ele).component ?= _initComponent ele
			# check if this event is triggered on this component
			i= targetIndx
			while i <= k
				try
					subEle = eventPath[i]
					continue unless subEle.hasAttribute eventAttrName
					listenerName = subEle.getAttribute eventAttrName
					continue unless listenerName
					listenerMethod = component[<%= component.listeners %>][listenerName]
					throw new Error "#{tagName} component: Unknown listener #{listenerName}" unless listenerMethod
					# wrap event
					eventClss = _watchSpecialEventsWrapper[eventName]
					unless eventClss
						eventClss = EventWrapper
					eventWrapper = new eventClss eventName, event, subEle, event.bubbles
					_defineProperties eventWrapper,
						target: value: target,
						component: value: component
					# trigger the event
					listenerMethod.call subEle, eventWrapper
					# break this event on this component 
					break unless eventWrapper.bubbles
				catch err
					Reactor.error 'Component-Exec>>', err
			# hide sub component
			target = ele
			targetIndx = k

###*
 * Browser special events
 * those events do not propagate
###
_defineBrowserSpecialEvents = (eventName, nativeEventName, listenerWrapper)->
	(event)->
		eventAttrName = ':' + eventName
		# get path
		target = event.target
		eventPath = event.path || _targetPathGen target
		# seek
		foundElements = []
		for ele,k in eventPath
			# add element if has this event attribute
			foundElements.push ele if ele.hasAttribute eventAttrName
			# check for component
			tagName = ele.tagName.toUpperCase()
			componentDescriptor = _components[tagName]
			continue unless componentDescriptor
			component = _data(ele).component ?= _initComponent ele
			# skip if no element with this event
			continue unless foundElements.length
			# call event for each element
			for subEl in foundElements
				try
					listenerName = subEle.getAttribute eventAttrName
					continue unless listenerName
					listenerMethod = component[<%= component.listeners %>][listenerName]
					throw new Error "#{tagName} component: Unknown listener #{listenerName}" unless listenerMethod
					# wrap event

					# wrap and call event
					listenerWrapper(listenerMethod).call subEle
				catch e
					# ...
				

###*
 * @private
 * Remove window event
 * @param {string} eventName - uppercased event name
###
_removeBrowserEvent= (eventName)->
	window.removeEventListener eventName, _browserListeners[eventName], true
	return