###*
 * Reactor
###
do ->
	#=include utils.coffee
	Reactor = window.Reactor = _create null
	#=include event_wrapper.coffee
	#=include data.coffee

	# watch events
	do ->
		#=include watch/watch.coffee
	return