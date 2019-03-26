gulp			= require 'gulp'
gutil			= require 'gulp-util'
# minify		= require 'gulp-minify'
include			= require "gulp-include"
rename			= require "gulp-rename"
coffeescript	= require 'gulp-coffeescript'
pug				= require 'gulp-pug'
through 		= require 'through2'
path			= require 'path'
PKG				= require './package.json'
# sass			= require 'gulp-sass'
sassCompiler	= require 'node-sass'


# settings
isProd= gutil.env.hasOwnProperty('prod')
settings=
	isProd: isProd

GfwCompiler		= require if isProd then 'gridfw-compiler' else '../compiler'

# check arguments
# SUPPORTED_MODES = ['node', 'browser']
# settings = gutil.env
# throw new Error '"--mode=node" or "--mode=browser" argument is required' unless settings.mode
# throw new Error "Unsupported mode: #{settings.mode}, supported are #{SUPPORTED_MODES.join ','}." unless settings.mode in SUPPORTED_MODES

# dest file name
# if settings.mode is 'node'
# 	destFileName = PKG.main.split('/')[1]
# else
destNodeFileName = PKG.main.split('/')[1]
destBrowserFileName= "#{PKG.name}.js"

# compile js (background, popup, ...)
compileCoffeeBrowser = ->
	gulp.src "assets/core/index.coffee"
		.pipe include hardFail: true
		.pipe gulp.dest "build"
		.pipe GfwCompiler.template({mode:'browser', ...settings}).on 'error', GfwCompiler.logError
		
		.pipe coffeescript(bare: true).on 'error', GfwCompiler.logError
		.pipe rename destBrowserFileName
		.pipe gulp.dest "build"
		.on 'error', GfwCompiler.logError
compileNode = ->
	gulp.src "assets/compiler.coffee"
		.pipe include hardFail: true
		.pipe GfwCompiler.template({mode:'node', ...settings}).on 'error', GfwCompiler.logError
		# .pipe gulp.dest "build"
		
		.pipe coffeescript(bare: true).on 'error', GfwCompiler.logError
		.pipe rename destNodeFileName
		.pipe gulp.dest "build"
		.on 'error', GfwCompiler.logError
compileGulp = ->
	gulp.src "assets/gulp.coffee"
		.pipe include hardFail: true
		.pipe GfwCompiler.template({mode:'node', ...settings}).on 'error', GfwCompiler.logError
		# .pipe gulp.dest "build"
		
		.pipe coffeescript(bare: true).on 'error', GfwCompiler.logError
		.pipe rename 'gulp-reactor'
		.pipe gulp.dest "build"
		.on 'error', GfwCompiler.logError
compileTests = ->
	gulp.src "test-assets/*.coffee"
		.pipe include hardFail: true
		# .pipe template settings
		# .pipe gulp.dest "test-build"
		
		.pipe coffeescript(bare: true).on 'error', GfwCompiler.logError
		.pipe gulp.dest "test-build"
		.on 'error', GfwCompiler.logError
compilePugTest = ->
	gulp.src "test-assets/*.pug"
		.pipe pug
			filters:
				sass: (text, options)->
					sassCompiler.renderSync data: text, indentedSyntax: on
		# .pipe template settings
		# .pipe gulp.dest "test-build"
		.pipe gulp.dest "test-build"
		.on 'error', GfwCompiler.logError


# client compiler
compileClientReactorTemplates = ->
	GulpReactor = require 'build/gulp-reactor'
	gulp.src 'test-assets/reactor-components/*.pug'
		.pipe GulpReactor.compileTemplates()
		.pipe rename 'my-reactor-components.js'
		.pipe dest 'test-build'

# compile
watch = (cb)->
	unless isProd
		gulp.watch 'assets/core/**/*.coffee', compileCoffeeBrowser
		gulp.watch 'assets/**/*.coffee', compileNode
		gulp.watch 'assets/gulp.coffee', compileGulp
		gulp.watch 'test-assets/**/*.coffee', compileTests
		gulp.watch 'test-assets/**/*.pug', compilePugTest
	return

# create default task
gulp.task 'default', gulp.series gulp.parallel(
	compileCoffeeBrowser, compileTests, compilePugTest, compileNode, compileGulp
	), watch #

