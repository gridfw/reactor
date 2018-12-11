

### my component ###
Reactor.define 'my-component',
	template: 'my-component'
	# path: 'absPath' # @optional, when has an absolute path to resolve this template
	attr: # or "properties" or "attrs"
		value:
			get: -> @querySelector('input.txt').value
			set: -> @querySelector('input.txt').value
		defaultValue:
			get: -> @querySelector('input.txt').defaultValue
	# private listeners
	# used inside tempate as: :eventName="listenerName"
	listeners:
		okClick: (event)->
			console.log '--- ok btn clicked'
		okHover: (event)->
			console.log '--- ok hovered ---'
		cancelClick: (event)->
			console.log '--- cancel clicked'