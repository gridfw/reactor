###*
 * Basic component prototype
###
COMPONENT_PROTOTYPE = create null,
	###*
	 * Join to an object of type Model
	###

	###*
	 * Set attribute
	 * @example
	 * self.setAttribute attrName: attrValue
	###
	setAttribute: (attrs)->

	###*
	 * Get attribute
	 * @example
	 * self.getAttribute attrName
	###
	getAttribute: (attrName)->

	###*
	 * get/set attributes
	 * @example
	 * self.attr attrName # get attribute
	 * self.attr attrName: attrValue # set attribute
	###
	attr: (attrs)->
		if typeof attrs is 'string'
			@getAttribute attrs
		else
			@setAttribute attrs