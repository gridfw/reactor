
# load templates
#=include load-template.coffee

# define components
#=include define.coffee

# browser
<% if(mode === 'browser'){ %>
#=include browser-init-component.coffee
#=include browser-events.coffee
<% } %>