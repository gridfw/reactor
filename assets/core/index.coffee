###*
 * Reactor
###
do ->
	DESCRIPTOR = Symbol 'DESCRIPTOR'
	#=include utils.coffee
	Reactor = window.Reactor = _create null
	#=include log.coffee
	<% if(mode === 'browser'){ %>
	#=include browser-utils.coffee
	#=include browser-data.coffee
	<% } %>

	# events
	#=include events/index.coffee

	# watch events
	do ->
		#=include watch/watch.coffee
	# define component
	do ->
		#=include components/index.coffee
	return