module.exports =
class AtomQuickCocos2dXView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-quick-cocos2d-x')

    # Create message element
    @message = document.createElement('div')
    @message.textContent = "The AtomQuickCocos2dX package is Alive! It's ALIVE!"
    @message.classList.add('message')
    @element.appendChild(@message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  setMsg: (content) ->
    @message.textContent = content

  getElement: ->
    @element
