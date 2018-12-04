###*
 * Move event
###
Reactor.addSpecialEvent 'move', 'mousedown', (orListener)->
	(event)->
		# mousemove
		mousemove = (evnt)=>
			data = _data this
			unless data.move
				data.move = [evnt.x, evnt.y, evnt.x, evnt.y] # [startX, startY, lastX, lastY, last-timestamp]
				# trigger move starts
				_triggerSelf this, 'movestart', new MoveEventWrapper evnt, this, data
			# trigger move
			listener.call this, new MoveEventWrapper evnt, this, data
			return
		window.addEventListener 'mousemove', mousemove, true
		# mouseup
		mouseUp = (evnt)=>
			window.removeEventListener 'mousemove', mousemove, true
			# trigger move ends
			data = _data this
			_triggerSelf this, 'moveend', new MoveEventWrapper evnt, this, data
			delete data.move
			return
		window.addEventListener 'mouseup', mouseup, {once: true, capture: true}
		return

