{ $ } = require('atom')

Template = """
<h3 id="zoltu-jspm-type-label"></h3>
<atom-text-editor id="zoltu-jspm-input-area" mini focusOnAttach></atom-text-editor>
"""

module.exports =
class ZoltuJspmTextView
	constructor: (serializedState) ->
		@element = document.createElement('zoltu-jspm-text-panel')
		@element.innerHTML = Template

	destroy: ->
		@element.remove()

	getElement: ->
		@element

	getInputArea: ->
		$('#zoltu-jspm-input-area').first().element

	getModel: ->
		@getInputArea().getModel()

	focus: ->
		typeLabel = $('#zoltu-jspm-type-label').first()
		switch @getModel().type
			when "install" then typeLabel.html('Install')
			when "uninstall" then typeLabel.html('Uninstall')
		@element.focus()
		@getInputArea().focus()
		@getModel().setText('')
