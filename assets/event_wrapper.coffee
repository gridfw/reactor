###*
 * Event wrapper
###
class EventWrapper
	constructor: (event, @bubbles=true)->
		@originalEvent = event
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

# getter values
_eventWrapperValueProxy = (keyName)->
	get: ->
		v= @originalEvent[keyName]
		_defineProperty this, keyName, value: v
		v
_defineProperties EventWrapper.prototype,
	altKey: _eventWrapperValueProxy 'altKey'
	ctrlKey: _eventWrapperValueProxy 'ctrlKey'
	shiftKey: _eventWrapperValueProxy 'shiftKey'
	defaultPrevented: _eventWrapperValueProxy 'defaultPrevented'
	x: _eventWrapperValueProxy 'x'
	y: get: ->
		e = @originalEvent



_eventPrototype = Object.create null
Object.defineProperties _eventPrototype,
	stopPropagation: ->
	stopImmediatePropagation() # just like native one

	preventDefault() # just like prevent default

	

	path: []

	x: clientX
	y: clientY
	timeStamp
	type
