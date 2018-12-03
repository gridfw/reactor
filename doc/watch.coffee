###*
 * Reactor.watch
 * This function will add special event listeners to elements selected
 * using there css selector
 * No native listener will be added to the element. the lib manage listeners
 * that's make elements more flexible (could be added and removed without woring about event listeners)
 * and faster
 * <!> all events are case unsensitive
###
Reactor.watch 'element_css_selector',	# passive watch, asyc listener, could not prevent or stop propagation
Reactor.on 'element_selector',			# active watch
	eventName: (event)-> # oeprations
	eventName: [(event)->, ...] # list of event listeners
	eventName:
		native: boolean # supported by some events, see "click" as example
		force: boolean # when true, the listener will be called even when event propagation is stoped by a child.
		passive: boolean # when true, the listner will be async called (could not call preventDefault or stopPropagation)
		listener: (event)-> # the listener to be called

	# examples
	dblClick: (event)-> #operations
	click:
		native: false # when false, click will be prevented when dbClick or move is set and captured
		force: false # when true, the listener will be called even the event propagation is stopped by a child
		listener: (event)-> # the listener

	# move
	move: ->
	moveStart: ->
	moveEnd: ->

# event
event= 
	target: HTML_Element # the target element
	currentTarget: HTML_Element # the captured element

	stopPropagation() # just like native stop propagation
	stopImmediatePropagation() # just like native one

	preventDefault() # just like prevent default

	altKey: boolean
	ctrlKey: boolean
	shiftKey: boolean
	bubbles: boolean
	defaultPrevented: boolean

	path: []

	x: clientX
	y: clientY
	timeStamp
	type

### special events ###
Reactor.watch 'selector'
	hover: (event) -> # when mouseover first time
	hout: (event) -> # when mouse out first time