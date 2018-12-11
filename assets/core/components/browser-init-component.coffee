###*
 * Init component
 * @param {htmlElement} htmlElement - html element
 * @return {Component} component
###
_initComponent = (htmlElement)->
	tagName = htmlElement.toUpperCase()
	componentDescriptor = _components[tagName]
	throw new Error "Uncknown component: #{tagName}" unless componentDescriptor
	component = _create componentDescriptor[<%= component.prototype %>],
		[DESCRIPTOR]: value: componentDescriptor
		$: value: htmlElement
	# return
	return component