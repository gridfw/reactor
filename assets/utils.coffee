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