###*
 * Event wrapper
###
class EventWrapper
	constructor: (event, @currentTarget, @bubbles)->
		@originalEvent = event
		@target = event.target
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
['altKey', 'ctrlKey', 'shiftKey', 'defaultPrevented', 'timeStamp', 'type', 'x', 'y', 'which'].forEach (keyName)->
	_defineProperty EventWrapperPrototype, keyName, get: ->
		v= @originalEvent[keyName]
		_defineProperty this, keyName, value: v
		v
# path
_defineProperty EventWrapperPrototype, 'path', get: ->
	_defineProperty this, 'path', value: _targetPathGen @target
	return v
