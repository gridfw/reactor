### move event wrapper ###
class MoveEventWrapper extends EventWrapper
	constructor: (event, currentTarget)->
		super event, currentTarget, off