# Server side:
# 		change Reactor.templateResolver = (templateName) -> templateAbsPath
# 		or set full path as templateName (not recommended)
# browser side:
# 		Reactor.templateResolver = (templateName) -> Promise.resolve {render: templateRenderFunction, events: ['click', ...]}

<% if(mode is 'node'){ %>
Reactor.templateResolver = (templateName)-> 

<% } %>

### my component ###
Reactor.define 'my-component',
	template: 'my-component.pug'
	attr: # or "attributes" or "attrs"
		value:
			get: -> @querySelector('input.txt').value
			set: -> @querySelector('input.txt').value
		defaultValue:
			get: -> @querySelector('input.txt').defaultValue
	# private listeners
	# used inside tempate as: :eventName="listenerName"
	listeners:
		okClick: (event)->
			console.log '--- ok btn clicked'
		okHover: (event)->
			console.log '--- ok hovered ---'
		cancelClick: (event)->
			console.log '--- cancel clicked'