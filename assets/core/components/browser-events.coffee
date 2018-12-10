###
define browser events
@private
###
_browserListeners = _create null
_defineBrowserEvent = (eventName)->
	throw new Error "Event [#{eventName}] already set" if _browserListeners[eventName]
	listener = _browserListeners[eventName] = (event)->
		eventAttrName = ':' + eventName
		# get path
		target = event.target
		eventPath = event.path || _targetPathGen target
		# seek
		for ele,k in eventPath
			# seek for component
			tagName = ele.tagName.toUpperCase()
			componentDescriptor = _components[tagName]
			continue unless componentDescriptor
			component = _data(ele).component ?= _initComponent ele
			# check if this event is triggered on this component
			i= 0
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
					eventWrapper = new eventClss event, subEle, event.bubbles
					_defineProperties eventWrapper,
						target: value: target,
						component: value: component
					# trigger the event
					listenerMethod.call subEle, eventWrapper
				catch err
					Reactor.error 'Component-Exec>>', err
			# hide sub component
			target = ele
	return