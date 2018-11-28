# create new element
Reactor.create 'div' # alias to: document.createnewelement 'div'
Reactor.create 'my-element' # create my-element
Reactor.create 'my-element', data # create my-element with data


# define new component
Reactor.define 'my-element',
	template: 'my-element.pug' # optional, the reactor will auto look for #{compoent-name}.pug
	extends: 'parent-element' # opitonal, when there is a parent element to extends
	# work with attributes
	setAttribute: (attrName, attrValue)-> # optional, general attribute setter
	getAttribute: (attName)-> # optional, general attribute getter
	# specific attribute getter/setter
	attr:
		attrName:
			get: ->
			set: (value) ->
		# method
		methodName: (args)->
	# private event listeners
	listeners:
		btn1Click: (event)->
		cancel: (event)->
		#...

# work with element
custElement = Reactor.querySelector 'cust-element#id'
custElement = Reactor.querySelectorAll 'cust-element#id'
custElement = Reactor.querySelector document.querySelector 'cust-element#id'
# set attributes
custElement.attr = 'value' # str value
custElement.attr = 152 # int value
custElement.attr = {value: 123} # object as value
custElement.setAttribute('attrName', 'data') # alias

custElement.count += 1
++custElement.count

# get attribtutes
attr = custElement.attr

# wait for element to be updated when attribute is changed
await custElement.updated # get update waiting promise
custElement.updated.then(cb)
