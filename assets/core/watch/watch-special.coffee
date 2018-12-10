###*
 * Watch special events
 * @param {string} eventName		- name of the event
 * @param {string} nativeEventName	- native event that will trigger this special event
 * @param {function} getListenerCb	- event trigger logic @return {function} listener
###
<%
var watchSpecialEvents = {
	listener : 0,
	nativeEvent: 1
};
%>
_defineProperty Reactor, 'addSpecialEvent',
	value: (eventName, nativeEventName, getListenerCb)->
		throw new Error "EventName expected string" unless typeof eventName is 'string'
		throw new Error "nativeEventName expected string" unless typeof nativeEventName is 'string'
		throw new Error "Third arg expected function" unless typeof getListenerCb is 'function'
		eventName = eventName.toLowerCase()
		throw new Error "EventName expected to match: #{_checkEventRegex.toString()}" unless _checkEventRegex.test eventName
		Reactor.warn 'addSpecialEvent>>', "Event wrapper [#{eventName}] overrided" if _watchSpecialEvents[eventName]

		_watchSpecialEvents[eventName]= [getListenerCb, nativeEventName]
		return


### wrap special event ###
_defineProperty Reactor, 'wrapEvent',
	value: (eventName, eventWrapper)->
		# check
		throw new Error "EventName expected string" unless typeof eventName is 'string'
		throw new Error "EventWrapper expected function" unless typeof eventWrapper is 'function'
		# fix eventName
		eventName = eventName.toLowerCase()
		throw new Error "EventName expected to match: #{_checkEventRegex.toString()}" unless _checkEventRegex.test eventName
		Reactor.warn 'wrapEvent>>', "Event wrapper [#{eventName}] overrided" if _watchSpecialEventsWrapper[eventName]
		# add
		_watchSpecialEventsWrapper[eventName] = eventWrapper
		# chain
		this
