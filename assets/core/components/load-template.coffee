###*
 * Load template into Reactor
###
_reactorTemplates = _create null
_defineProperty Reactor, 'loadTemplate', value: (template)->
	throw new Error "Illegal arguments" unless arguments.length is 1 and typeof template is 'object' and template
	templateName = template.name
	throw new Error "template.name expected string" unless typeof templateName is 'string'
	throw new Error "Expected template.events" unless template.events
	throw new Error "Illegal template.events" unless template.events.every? (el)-> typeof el is 'string'
	throw new Error "template.render expected function" unless typeof template.render is 'function'
	throw new Error "template [#{template.name}] already set" if _reactorTemplates[templateName]

	_reactorTemplates[templateName] = template.render

	# add events when browser
	<% if(mode === 'browser') { %>
	_defineBrowserEvent evName for evName in template.events
	<% } %>