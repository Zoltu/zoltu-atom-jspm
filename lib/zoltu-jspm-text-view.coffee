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
		return document.getElementById('zoltu-jspm-input-area');

	getModel: ->
		@getInputArea().getModel()

	focus: ->
		typeLabel = document.getElementById('zoltu-jspm-type-label')
		switch @getModel().type
			when "install" then typeLabel.innerText = 'Install'
			when "uninstall" then typeLabel.innerText = 'Uninstall'
		@element.focus()
		@getInputArea().focus()
		@getModel().setText('')
