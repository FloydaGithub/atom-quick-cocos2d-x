AtomQuickCocos2dXView = require './atom-quick-cocos2d-x-view'
{CompositeDisposable} = require 'atom'
exec = require('child_process').exec
path = require('path')
fs = require('fs')


module.exports = AtomQuickCocos2dX =
  atomQuickCocos2dXView: null
  modalPanel: null
  subscriptions: null
  quick_dir: null

  activate: (state) ->
    @atomQuickCocos2dXView = new AtomQuickCocos2dXView(state.atomQuickCocos2dXViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomQuickCocos2dXView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    # @subscriptions.add atom.commands.add 'atom-workspace', 'quick-cocos2d-x:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'quick-cocos2d-x:run': => @run()

    # add quick path
    for p in atom.packages.packageDirPaths
      @quick_dir = path.join(p, 'atom-quick-cocos2d-x/lib/quick')

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomQuickCocos2dXView.destroy()

  serialize: ->
    atomQuickCocos2dXViewState: @atomQuickCocos2dXView.serialize()

  toggle: ->
    console.log 'AtomQuickCocos2dX was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  joinFileToPath: (filePath) ->
    try
      tmfFile = path.join(@quick_dir, filePath)
      fstate = fs.statSync(tmfFile)
      if fstate.isFile()
        tmfFile
    catch error
      null

  sendMsg: (content) ->
    @atomQuickCocos2dXView.setMsg(content)
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      setTimeout((hide) =>
          @modalPanel.hide()
        ,1500)

  run: ->
    editor = atom.workspace.getActiveTextEditor();
    filePath = editor.getPath();
    RunQuickSimulator = @joinFileToPath "RunQuickSimulator.py"
    if RunQuickSimulator
      cmd = exec("python #{RunQuickSimulator} " + filePath)
      cmd.on("exit", (code, signal) =>
        @sendMsg("please set environment variable 'QUICK_V3_ROOT'") if code is 1
        )
