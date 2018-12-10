###*
 * Move event
 * data.move = 
###
# [isFirstMoving, originalX, originalY, lastX, lastY, lastTimeStamp, dx, dy, dt]
_moveData = null
# mouse down to move
_moveEvent = (eventName, evnt)->
	new MouseEvent eventName,
		bubbles: on
		cancelable: true
		view: window
		which: 1
		shiftKey: evnt.shiftKey
		altKey: evnt.altKey
		ctrlKey: evnt.ctrlKey
		timeStamp: evnt.timeStamp
		clientX: evnt.clientX
		clientY: evnt.clientY
_moveMouseDown = (event)->
	# accept only right button
	return unless event.which is 1
	# mousemove
	mousemove = (evnt)=>
		x = evnt.clientX
		y = evnt.clientY
		tme= evnt.timeStamp
		if _moveData
			_moveData[6] = x - _moveData[3]
			_moveData[7] = y - _moveData[4]
			_moveData[8] = tme - _moveData[5]
		else
			_moveData = [yes, x, y, x, y, tme, 0, 0, 0]
			return
		# trigger move starts
		if _moveData[0]
			_moveData[0] = no
			event.target.dispatchEvent new _moveEvent 'movestart', evnt
		# trigger move
		event.target.dispatchEvent new _moveEvent 'move', evnt
		# set new values
		_moveData[3] = x
		_moveData[4] = y
		_moveData[5] = tme
		return
	window.addEventListener 'mousemove', mousemove, true
	# mouseup
	mouseUp = (evnt)=>
		window.removeEventListener 'mousemove', mousemove, true
		# trigger move ends
		if _moveData
			unless _moveData[0]
				event.target.dispatchEvent new _moveEvent 'moveend', evnt
			_moveData = null
		return
	window.addEventListener 'mouseup', mouseUp, {once: true, capture: true}
	return
	
window.addEventListener 'mousedown', _moveMouseDown, true

### move event wrapper ###
class MoveEventWrapper extends EventWrapper
	constructor: (event, currentTarget, bubbles)->
		super event, currentTarget, bubbles
		# calc
		x = event.clientX
		y = event.clientY
		tme= event.timeStamp
		_defineProperties this,
			timeStamp: value: tme
			originalX: value: _moveData[1]
			originalY: value: _moveData[2]
			# lastX: value: _moveData[3]
			# lastY: value: _moveData[4]
			x: value: x
			y: value: y
			dx: value: _moveData[6]
			dy: value: _moveData[7]
			dt: value: _moveData[8]
		return

# wrap events
Reactor.wrapEvent 'move', MoveEventWrapper
Reactor.wrapEvent 'moveStart', MoveEventWrapper
Reactor.wrapEvent 'moveEnd', MoveEventWrapper