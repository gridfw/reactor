###*
 * Watch special events
 * @param {string} eventName		- name of the event
 * @param {string} nativeEventName	- native event that will trigger this special event
 * @param {function} getListenerCb	- event trigger logic @return {function} listener
###
_defineProperty Reactor, 'addSpecialEvent',
	value: (eventName, nativeEventName, getListenerCb)->
		throw new Error "EventName expected string" unless typeof eventName is 'string'
		throw new Error "nativeEventName expected string" unless typeof nativeEventName is 'string'
		throw new Error "Third arg expected function" unless typeof addCb is 'function'
		throw new Error "Event #{eventName} already set" if _watchSpecialEvents[eventName]

		_watchSpecialEvents[eventName]=
			getListener	: getListenerCb
			nativeEvent : nativeEventName
		return

_watchSpecialEvents=

	###*
	 * Move
	 * triggers moveStart, moveEnd
	###
	move:
		add: (selector, eventDescriptor, eventGrp)->
			listener = eventDescriptor.listener
			desc = _clone eventDescriptor
			desc.listener = (evnt)->
				# mousemove
				mousemove = (event)=>
					data = _data this
					moveEvent = new MoveEventWrapper event, this
					unless data.move
						data.move = [event.x, event.y, event.x, event.y] # [startX, startY, lastX, lastY, last-timestamp]
						# trigger move starts
						_triggerSelf this, 'movestart', {}
					# trigger move
					listener.call this, moveEvent
					return
				window.addEventListener 'mousemove', mousemove, true
				# mouseup
				mouseUp = (event)=>
					window.removeEventListener 'mousemove', mousemove, true
					# trigger move ends
					data = _data this
					delete data.move
					_trigger this, 'moveend', {} if (_data this).move
					return
				window.addEventListener 'mouseup', mouseup, {once: true, capture: true}
				return
			_watchRegisterNativeEvent 'move', 'mousedown', eventGrp, desc, selector
			return
		nativeEvent: 'mousedown'
