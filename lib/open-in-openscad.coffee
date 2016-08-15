path = require 'path'
{CompositeDisposable} = require 'atom'
pty = require 'pty.js'

console.log 'activating openInOpenScad package'
module.exports = YourNameWordCount =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'open-in-openscad:open': => @openInOpenScad()

  deactivate: ->
    @subscriptions.dispose()
    @wordcountView.destroy()

  serialize: ->
    #

  openInOpenScad: ->
    editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    extension = path.extname(filePath) or path.basename(filePath)
    fileLongName = editor.getLongTitle()

    if extension.toLowerCase() == '.scad'
      atom.notifications.addSuccess "Opening \"#{fileLongName}\" in OpenSCAD"
      command = "openscad \""+ filePath + "\""
      pty.spawn '/bin/bash', ['-c', command]
    else
      atom.notifications.addError "Invalid extension type " + extension + ". Please try on a SCAD file"
