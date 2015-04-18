{ CompositeDisposable, BufferedNodeProcess } = require 'atom'
path = require 'path'
ZoltuJspmTextView = require './zoltu-jspm-text-view'

module.exports = ZoltuJspm =
	view: null
	panel: null
	model: null
	subscriptions: null

	activate: ->
		@view = new ZoltuJspmTextView()

		@panel = atom.workspace.addModalPanel(item: @view.getElement(), visible: false)
		@model = @view.getModel()

		# Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
		@subscriptions = new CompositeDisposable

		# Register commands
		@subscriptions.add atom.commands.add 'atom-workspace', 'zoltu-jspm:toggle-install': => @toggleInstall()
		@subscriptions.add atom.commands.add 'atom-workspace', 'zoltu-jspm:toggle-uninstall': => @toggleUninstall()
		@subscriptions.add atom.commands.add 'atom-workspace', 'zoltu-jspm:init': => @init()
		@subscriptions.add atom.commands.add 'zoltu-jspm-text-panel atom-text-editor', 'core:confirm': (event) => @confirm(event)
		@subscriptions.add atom.commands.add 'zoltu-jspm-text-panel atom-text-editor', 'core:cancel': (event) => @close(event)

	deactivate: ->
		@panel.destroy()
		@subscriptions.dispose()
		@view.destroy()

	toggleInstall: ->
		@toggleView "install"

	toggleUninstall: ->
		@toggleView "uninstall"

	toggleView: (type) ->
		if @panel.isVisible() && type == @model.type
			@panel.hide()
		else
			@model.type = type
			@panel.show()
			@view.focus()

	init: ->
		@executeJspm [ 'init' ]

	confirm: (event) ->
		@panel.hide()
		type = @model.type
		packageName = @model.getText()
		switch type
			when "install" then @install(packageName)
			when "uninstall" then @uninstall(packageName)

	close: (event) ->
		@panel.hide()

	install: (packageName) ->
		args = [ 'install', packageName ]
		@executeJspm args

	uninstall: (packageName) ->
		args = [ 'uninstall', packageName ]
		@executeJspm args

	executeJspm: (args) ->
		if @process
			@process.kill()
			@process = null

		command = @pathToJspm()
		options =
			cwd: atom.project.getPath()
			env: { ATOM_SHELL_INTERNAL_RUN_AS_NODE: '1', PATH: @pathToGitDirectory() }
		@process = new BufferedNodeProcess({command, args, options, stdout: @jspmLogInfo, stderr: @jspmLogError, exit: @jspmExit})

	pathToJspm: ->
		return path.join(atom.project.getPath(), 'node_modules', 'jspm', 'jspm.js')

	pathToGitDirectory: ->
		gitDirectory = "C:\\Program Files (x86)\\Git\\bin\\"
		if fs.existsSync(gitDirectory)
			return gitDirectory

		return "git"

	jspmLogInfo: (message) ->
		message = message.trim()
		if message.startsWith("err")
			type = 'error'
			message = message.replace('err', '')
		else if message.startsWith("warn")
			type = 'warning'
			message = message.replace('warn', '')
		else if message.startsWith("ok")
			type = 'info'
			message = message.replace('ok', '')
		else
			type = 'info'

		message = message.trim()
		atom.notifications.add(type, 'JSPM', dismissable: true, detail: message)

	jspmLogError: (message) ->
		atom.notifications.addError('JSPM', dismissable: true, detail: message)

	jspmExit: (exitCode) ->
		if exitCode == 0
			atom.notifications.addSuccess('JSPM', dismissable: true, detail: "JSPM operation completed successfully!")
		else
			atom.notifications.addError('JSPM', dismissable: true, detail: "JSPM operation did not complete successfully.")
