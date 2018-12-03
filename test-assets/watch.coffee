console.log '--- watch'

Reactor.watch 'a.test1',
	click: (event)->
		console.log '--- a clicked: ', event.currentTarget
		console.log '--- target: ', event.target
		event.preventDefault()
		return
	mouseover: (event)->
		@style.background = 'red'
	mouseout: (event)->
		@style.background=''


Reactor.watch '.test2',
	mouseover: (event)-> console.log '*** mouseover'
	hover: (event)-> console.log '--- hOver'
	mouseout: (event)-> console.log '*** mouseout'
	hout: (event)-> console.log '--- hOut'