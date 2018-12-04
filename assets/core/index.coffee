###*
 * Reactor
###
do ->
	#=include utils.coffee
	Reactor = window.Reactor = _create null
	#=include log.coffee
	#=include event_wrapper.coffee
	#=include data.coffee

	# watch events
	do ->
		#=include watch/watch.coffee
	# define component
	do ->
		#=include components/index.coffee
	return