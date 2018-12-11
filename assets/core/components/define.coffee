###*
 * Define components
 * @param {string} componentName - Name of the component to add
 * @optional @param {string} options.template - name of the template to use to render this component, @default component name
 * @optional @param {Map internal listeners} options.listeners - Map of internal listeners used inside browser
 * @optional @param {Map} attr - Map of external properties (methods and attributes) @see documentation
 * @optional @param {Map} attrs - alias to attr
 * @optional @param {Map} properties - alias to attr
###
_components = _create null
COMPONENT_NAME_CHECK = /^[A-Z][A-Z-]+[A-Z]$/
# component architecture
<%
	var componentAttr = [
		'listeners'
		'render' # function that will render this component
	];
	var component = Object.create(null);
	for(var i=0, len=componentAttr.length; i<len; ++i)
		component[componentAttr[i]] = i;
%>
# browser flags
<% if(mode === 'browser'){ %>
_immediateDefineStyle = null
<% } %>
# define
_defineProperty Reactor, 'define', value: (componentName, options)->
	# checks
	throw new Error "Component name expected string" unless typeof componentName is 'string'
	throw new Error 'Illegal arguments' unless arguments.length is 2 and typeof options is 'object' and options
	componentName = componentName.toUpperCase()
	throw new Error "Component name must match: #{COMPONENT_NAME_CHECK.toString()}, got <#{componentName}>" unless COMPONENT_NAME_CHECK.test componentName
	throw new Error "Component with some name <#{componentName}> are already set" if _components[componentName]
	# extends
	# template check
	throw new Error "options.template expected string" unless typeof options.template is 'string' 
	# add component
	component = _components[componentName] = []
	# browser
	<% if(mode === 'browser') { %>
	# define basic style for the new component when navigator
	clearImmediate _immediateDefineStyle if _immediateDefineStyle
	_immediateDefineStyle = setImmediate _enableComponentBasicStyle
	# define listeners
	if 'listeners' of options
		for k,v of options.listeners
			throw new Error "listeners.#{k} expected function" unless typeof v is 'function'
		component[<%= component.listeners %>] = options.listeners
	<% } %>
	# check for render
	unless component[<%= component.render %>] = _reactorTemplateRender[options.template]
		throw new Error "Unknown template: #{options.template}"

	# chain
	this

# create component basic style in browsers
<% if(mode === 'browser') { %>
_styleTagId = 'Reactor-' + Math.random().toString(32).substr(2)
_enableComponentBasicStyle = ->
	# get style tag
	styleTag = document.getElementById _styleTagId
	unless styleTag
		styleTag = document.createElement 'style'
		document.head.insertBefore styleTag, document.head.firstChild
	# create syle
	stl = Object.keys(_components).join(',')
	stl += '{display:block}' if stl
	styleTag.innerText = stl
<% } %>