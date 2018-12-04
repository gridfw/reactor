###*
 * Move event
 * data.move = [isFirstMoving, originalX, originalY, lastX, lastY, lastTimeStamp]
###
_moveEvntId = 0
Reactor.addSpecialEvent 'move', 'mousedown', (orListener)->
	mvId = 'move-' + _moveEvntId
	(event)->
		# accept only right button
		return unless event.which is 1
		# mousemove
		mousemove = (evnt)=>
			data = _data this
			# this event is called on mouse down, so do not trigger until first move
			dataMove = data[mvId]
			unless dataMove
				data[mvId] = [on, evnt.x, evnt.y, evnt.x, evnt.y]
				return
			# first move
			if dataMove[0]
				dataMove[0] = off
				# trigger move starts
				_triggerSelf this, 'movestart', new MoveEventWrapper evnt, this, dataMove
			# trigger move
			orListener.call this, new MoveEventWrapper evnt, this, dataMove
			return
		window.addEventListener 'mousemove', mousemove, true
		# mouseup
		mouseUp = (evnt)=>
			window.removeEventListener 'mousemove', mousemove, true
			# trigger move ends
			data = _data this
			dataMove = data[mvId]
			if dataMove
				unless dataMove[0]
					_triggerSelf this, 'moveend', new MoveEventWrapper evnt, this, dataMove
				delete data[mvId]
			return
		window.addEventListener 'mouseup', mouseUp, {once: true, capture: true}
		return


### move event wrapper ###
class MoveEventWrapper extends EventWrapper
	constructor: (event, currentTarget, coord)->
		super event, currentTarget, off
		# calc
		x = event.x
		y = event.y
		tme= event.timeStamp
		_defineProperties this,
			originalX: value: coord[1]
			originalY: value: coord[2]
			lastX: value: coord[3]
			lastY: value: coord[4]
			x: value: x
			y: value: y
			dx: value: x - coord[3]
			dy: value: y - coord[4]
			dt: value: tme - coord[5]
		# set new values
		coord[3] = x
		coord[4] = y
		coord[5] = tme
		return