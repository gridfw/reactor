###*
 * Load template into Reactor memory
 * Used espacially for browsers
###
_reactorTemplateRender = _create null
_defineProperty Reactor, 'loadTemplate', value: (template)->
	# checks
	throw new Error "Illegal arguments" unless arguments.length is 1 and typeof template is 'object' and template
	templateName = template.name
	throw new Error "template.name expected string" unless typeof templateName is 'string'
	templateName = templateName.toLowerCase()
	throw new Error "Expected template.events" unless template.events
	throw new Error "Illegal template.events" unless template.events.every? (el)-> typeof el is 'string'
	throw new Error "template.render expected function" unless typeof template.render is 'function'
	Reactor.warn 'Load template>>', "Override template: #{templateName}" if _reactorTemplateRender[templateName]

	# save render
	_reactorTemplateRender[templateName] = template.render

	# add events when browser
	<% if(mode === 'browser') { %>
	for evName in template.events
		_defineBrowserEvent evName unless _browserListeners[evName]
	<% } %>
	# chain
	this