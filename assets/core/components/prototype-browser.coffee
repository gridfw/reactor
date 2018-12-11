###*
 * Browser prototypes
###
_defineProperties COMPONENT_PROTOTYPE,
	###*
	 * DOM accessors
	###
	querySelector: get: -> @$.querySelector
	querySelectorAll: get: -> @$.querySelectorAll

	###*
	 * Empty element content
	###
	clear: value: ->
		ele = @$
		while ele.firstChild
			ele.removeChild ele.firstChild
		# chain
		this
	###*
	 * Reload template
	###
	reload: value: ->
		# Render HTML
		renderFx = @[DESCRIPTOR][<%= component.render %>]
		# empty existing element
		do @clear
		# add element HTML
		@$.innerHTML = renderFx this
		# chain
		this