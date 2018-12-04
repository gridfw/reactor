### move event wrapper ###
class MoveEventWrapper extends EventWrapper
	constructor: (event, currentTarget, data)->
		super event, currentTarget, off
		# calc
		coord = data.move
		x = event.x
		y = event.y
		tme= event.timeStamp
		_defineProperties this,
			originalX: value: coord[0]
			originalY: value: coord[1]
			lastX: value: coord[2]
			lastY: value: coord[3]
			x: value: x
			y: value: y
			dx: x - coord[2]
			dy: y - coord[3]
			dt: tme - coord[4]
		# set new values
		coord[2] = x
		coord[3] = y
		coord[4] = tme
		return