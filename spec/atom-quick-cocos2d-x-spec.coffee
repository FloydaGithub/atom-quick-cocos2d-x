AtomQuickCocos2dX = require '../lib/atom-quick-cocos2d-x'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomQuickCocos2dX", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atom-quick-cocos2d-x')

  describe "when the atom-quick-cocos2d-x:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.atom-quick-cocos2d-x')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'atom-quick-cocos2d-x:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.atom-quick-cocos2d-x')).toExist()

        atomQuickCocos2dXElement = workspaceElement.querySelector('.atom-quick-cocos2d-x')
        expect(atomQuickCocos2dXElement).toExist()

        atomQuickCocos2dXPanel = atom.workspace.panelForItem(atomQuickCocos2dXElement)
        expect(atomQuickCocos2dXPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'atom-quick-cocos2d-x:toggle'
        expect(atomQuickCocos2dXPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.atom-quick-cocos2d-x')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'atom-quick-cocos2d-x:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        atomQuickCocos2dXElement = workspaceElement.querySelector('.atom-quick-cocos2d-x')
        expect(atomQuickCocos2dXElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'atom-quick-cocos2d-x:toggle'
        expect(atomQuickCocos2dXElement).not.toBeVisible()
