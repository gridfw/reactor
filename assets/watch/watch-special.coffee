###*
 * Watch special events
###

_watchSpecialEvents=
	###*
	 * hover
	 * call this when mouse pointer enters to the element
	 * will not call mouseout intel the pointer physically quit the element
	 * @param {Object} eventDescriptor - {passive:boolean, force:boolean, listener:function(event){}}
	###
	hover:
		add: (selector, eventDescriptor)->
			_watchHoverOut selector, eventDescriptor, eventDescriptor.listener, null
			return
	###*
	 * hOut
	 * when mouse quit the element (not propaged event)
	 * @type {[type]}
	###
	hout:
		add: (selector, eventDescriptor)->
			_watchHoverOut selector, eventDescriptor, null, eventDescriptor.listener
			return
	###*
	 * Move
	 * triggers moveStart, moveEnd
	###
	move:
		add: (selector, eventDescriptor)->
			listener = eventDescriptor.listener
			desc = _clone eventDescriptor
			desc.listener = (evnt)->
				# mousemove
				mousemove = (event)=>
					data = _data this
					moveEvent = new MoveEventWrapper event, this
					unless data.move
						data.move = [event.x, event.y, event.x, event.y] # [startX, startY, lastX, lastY, last-timestamp]
						# trigger move starts
						_triggerSelf this, 'movestart', {}
					# trigger move
					listener.call this, moveEvent
					return
				window.addEventListener 'mousemove', mousemove, true
				# mouseup
				mouseUp = (event)=>
					window.removeEventListener 'mousemove', mousemove, true
					# trigger move ends
					data = _data this
					delete data.move
					_trigger this, 'moveend', {} if (_data this).move
					return
				window.addEventListener 'mouseup', mouseup, {once: true, capture: true}
				return
			_watchRegisterNativeEvent 'mousedown', desc, selector
			return
###*
 * watch hover, out
###
_watchHoverOutListeners = 0
_watchHoverOut = (selector, eventDescriptor, onOver, onOut) ->
	desc = _clone eventDescriptor
	randomId = 'mover-' + (++_watchHoverOutListeners)
	desc.listener = (event)->
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
	_watchRegisterNativeEvent 'mouseover', desc, selector
	return
