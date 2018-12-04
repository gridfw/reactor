######
###*
 * hover
 * call this when mouse pointer enters to the element
 * will not call mouseout intel the pointer physically quit the element
 * @param {Object} eventDescriptor - {passive:boolean, force:boolean, listener:function(event){}}
###
Reactor.addSpecialEvent 'hover', 'mouseover', (orListener)-> _watchHoverOut orListener, null

###*
 * hOut
 * when mouse quit the element (not propaged event)
 * @type {[type]}
###
Reactor.addSpecialEvent 'hout', 'mouseover', (orListener)-> _watchHoverOut null, orListener

###*
 * watch hover, out
###
_watchHoverOutListeners = 0
_watchHoverOut = (onOver, onOut) ->
	randomId = 'mover-' + (++_watchHoverOutListeners)
	return (event)->
		data = _data this
		# call when not already hover
		unless data[randomId]
			onOver.call this, event if onOver
			data[randomId] = yes
			# out listener
			outListener = (event2)=>
				el = event2.target
				while el isnt document
					return if el is this
					el = el.parentNode
				data[randomId] = no
				window.removeEventListener 'mouseover', outListener, true
				onOut.call this, (new EventWrapper event, this, event.bubbles) if onOut
				return
			window.addEventListener 'mouseover', outListener, true
		return
