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
		nativeEventName = evSpecial[<%= watchSpecialEvents.nativeEvent %>]
		listener = _defineBrowserSpecialEvents eventName, nativeEventName, evSpecial[<%= watchSpecialEvents.listener %>]
	else
		nativeEventName = eventName
		listener = _defineBrowserBublleEvent eventName
	_browserListeners[eventName] = [nativeEventName, listener]
	window.addEventListener nativeEventName, listener, true
	return

###*
 * @private
###
_browserWrapEvent = (eventName, event, subEle, target, component)->
	eventClss = _watchSpecialEventsWrapper[eventName]
	unless eventClss
		eventClss = EventWrapper
	eventWrapper = new eventClss eventName, event, subEle, event.bubbles
	_defineProperties eventWrapper,
		target: value: target,
		component: value: component
	return eventWrapper
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
					eventWrapper = _browserWrapEvent eventName, event, subEle, target, component
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
			# check for component
			tagName = ele.tagName.toUpperCase()
			# call event for each element
			if _components[tagName] and foundElements.length
				component = _data(ele).component ?= _initComponent ele
				for subEle in foundElements
					try
						listenerName = subEle.getAttribute eventAttrName
						continue unless listenerName
						listenerMethod = component[<%= component.listeners %>][listenerName]
						throw new Error "#{tagName} component: Unknown listener #{listenerName}" unless listenerMethod
						# wrap event
						eventWrapper = _browserWrapEvent eventName, event, subEle, target, component
						# wrap and call event
						listenerWrapper(listenerMethod).call subEle, eventWrapper
					catch err
						Reactor.error 'Emit-event>>', err
				# empty
				foundElements.length = 0
			# add element if has this event attribute
			foundElements.push ele if ele.hasAttribute eventAttrName
		# warn if some elements found without component
		Reactor.warn 'Emit-event', "Found events without component at: #{foundElements.map(_elementCssSelector).join(', ')}" if foundElements.length
		return
			
###*
 * @private
 * Remove window event
 * @param {string} eventName - uppercased event name
###
_removeBrowserEvent= (eventName)->
	ev = _browserListeners[eventName]
	window.removeEventListener ev[0], ev[1], true
	return