### utils ###

_create = Object.create
_defineProperty = Object.defineProperty
_defineProperties = Object.defineProperties

###*
 * Create random attribute name
###
_randAttr = (obj, prefix)->
	loop
		attr = prefix + Math.random().toString(32).substr(2)
		unless attr of obj
			return attr

_clone = (obj)->
	Object.assign (_create null), obj

# Set immediate on browsers
if typeof setImmediate is 'undefined'
	setImmediate = (cb)-> setTimeout cb, 0
	clearImmediate= (id)-> clearTimeout id

