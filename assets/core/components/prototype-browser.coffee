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
		@emit 'beforeUpdate'
		# Render HTML
		renderFx = @[DESCRIPTOR][<%= component.render %>]
		# empty existing element
		do @clear
		# add element HTML
		@$.innerHTML = renderFx this
		@emit 'updated'
		# chain
		this
	###*
	 * return promise when a new update is validated
	###
	updated: get:-> new Promise (resolve, reject)=>
		@once 'updated', (evnt)=>
			do resolve if evnt.target is this
		return


	###*
	 * Emit event on the component
	 * @example
	 * self.emit customEvent # emit this event
	 * self.emit eventName # emit CustomEvent(eventName)
	 * self.emit eventName, options # emit CustomEvent(eventName, options)
	###
	emit: value: (event, options)->
		switch arguments.length
			when 1
				if typeof event is 'string'
					event = new new CustomEvent event, bubbles: on, cancelable: on
			when 2
				throw new Error "expected string as event name" unless typeof event is 'string'
				throw new Error "Illegal event options" unless typeof options is 'object' and options
				event = new CustomEvent event, options
			else
				throw new Error "Illegal arguments"
		@$.dispatchEvent event
		# chain
		this
	###*
	 * add event listener
	###
	on: value: (eventName, listener)->
		@$.addEventListener eventName, listener, off
		this
	once: value: (eventName, listener)->
		@$.addEventListener eventName, listener, once: yes, capture: no
		this
	off: value: (eventName, listener)->
		#TODO enable to remove all specific event listeners
		@$.removeEventListener eventName, listener, off
		this