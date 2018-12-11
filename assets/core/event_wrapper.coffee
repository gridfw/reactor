###*
 * Event wrapper
###
class EventWrapper
	constructor: (eventName, event, @currentTarget, @bubbles)->
		@originalEvent = event
		@target = event.target
		@type = eventName
		return
	# stop propagation inside framework registered listeners
	# this do not affect native 
	stopPropagation: ->
		@bubbles = off
		this
	# stop immediate propagation
	stopImmediatePropagation: ->
		@bubbles = off
		@bubblesImmediate = off
		this
	# prevent default, this will affect native
	preventDefault: ->
		@originalEvent.preventDefault()
		this

EventWrapperPrototype = EventWrapper.prototype
# getter values
['altKey', 'ctrlKey', 'shiftKey', 'defaultPrevented', 'timeStamp', ['x', 'clientX'], ['y', 'clientY'], 'which'].forEach (keyName)->
	if typeof keyName is 'string'
		attrGet = ->
			v= @originalEvent[keyName]
			_defineProperty this, keyName, value: v
			v
	else
		attrGet = ->
			ev= @originalEvent
			for att in keyName
				v = ev[att]
				break if v
			_defineProperty this, keyName[0], value: v
			v
	_defineProperty EventWrapperPrototype, keyName, get: attrGet
	return

# path
_defineProperties EventWrapperPrototype,
	###*
	 * Path
	###
	path: get: ->
		v = _targetPathGen @target
		_defineProperty this, 'path', value: v
		return v
