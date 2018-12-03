###*
 * Reactor
###
do ->
	#=include utils.coffee
	Reactor = window.Reactor = _create null
	#=include event_wrapper.coffee
	#=include data.coffee

	#=include watch/watch.coffee
	return