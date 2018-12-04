### Gulp for Reactor ###
through = require 'through2'
Reactor	= require '.'

###*
 * Gulp for Reactor
 * @optional @param  {funtion} options.templateResolver - resolve template path
 * @optional @param {string} path - folder containing templates, @default each file path
###
module.exports = (options)->
	resolver = (file, encoding, callback) ->
		err = null
		try
			# get file string
			content = file.contents.toString 'utf8'
			
		catch e
			err = e
		callback e
	return through.obj resolver
