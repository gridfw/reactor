'use strict'

PUG = require 'pug'
PATH = require 'path'

console.log '---- compile pug'

compile = (filePath)->
	PUG.renderFile filePath,
		self: on
		pretty: on
		filters:[]
		# plugings
		plugins:[
			# lexer
			lex: 
				tag: (value)->
					console.log '--- preLex', value
					value
			# lex: -> console.log '--- lex'
			postLex:(value)->
				console.log '--- args: ', value
				value
				# console.log '--- lex: ', Object.keys this
					# console.log '--- tokens: ', @tokens.length
			# parse: ->
			# 	console.log '--- parse'
		]
		# data
		image:
			src: 'kkk.jpg'
			width: 200
			height: 625


console.log compile PATH.join __dirname, 'test1.pug'