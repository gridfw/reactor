###*
 * Init component
###
_initComponent = (htmlElement)->
	tagName = htmlElement.toUpperCase()
	componentDescriptor = _components[tagName]
	throw new Error "Uncknown component: #{tagName}" unless componentDescriptor