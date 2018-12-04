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
		throw new Error "Third arg expected function" unless typeof getListenerCb is 'function'
		throw new Error "Event #{eventName} already set" if _watchSpecialEvents[eventName]

		_watchSpecialEvents[eventName]=
			getListener	: getListenerCb
			nativeEvent : nativeEventName
		return