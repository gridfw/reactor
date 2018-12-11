
# prototype
#=include prototype.coffee
<% if(mode === 'browser'){ %>
#=include prototype-browser.coffee
<% } %>


# load templates
#=include load-template.coffee

# define components
#=include define.coffee

# browser
<% if(mode === 'browser'){ %>
#=include browser-init-component.coffee
#=include browser-events.coffee
<% } %>