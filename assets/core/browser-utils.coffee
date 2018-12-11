###*
 * Generate element DOM path
###
_targetPathGen = (ele)->
	v = []
	loop
		v.push ele
		ele = ele.parentNode
		break unless ele
	v.push window
	return v

###*
 * Get element css selector
 * @type {[type]}
###
_elementCssSelector = (ele)->
	path = []
	loop
		break if ele is document
		if ele is document.body
			path.push 'body'
			break
		# id
		if ele.id
			path.push '#' + ele.id
			break
		# index
		idx = 1
		el = ele
		while el = el.previousElementSibling
			++idx
		# class
		cls = ele.className.trim().replace(/\s+/, '.')
		cls = '.' + cls if cls
		path.push "#{ele.tagName.toLowerCase()}#{cls}:nth-child(#{idx})"
	return path.join '>'
