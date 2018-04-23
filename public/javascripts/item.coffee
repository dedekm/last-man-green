class Item extends Phaser.Sprite
  constructor: (game, x, y, key, frame, id) ->
    super game, x, y, key, frame
    @inputEnabled = true
    @events.onInputDown.add( (item, pointer) ->
      if pointer.leftButton.isDown
        if @game.itemClicked
          @game.hero.comment @game.combinations.check(@game.itemClicked, item)
          @game.itemClicked.returnToInventory()
        else if @pickable()
          @game.itemClicked = item
        else if @inInventory()
          item.inputEnabled = false
          item.fixedToCamera = false
          @game.itemClicked = item
          @game.world.bringToTop(item)
      else if pointer.rightButton.isDown
        @game.hero.comment @comment
    , this)
    
    @id = id || key
    @comment = ''
    @state = 'pickable'
  
  pickable: ->
    @state == 'pickable'
    
  inInventory: ->
    @state == 'inventory'
    
  inHand: ->
    @inInventory() && @game.itemClicked == this
  
  returnToInventory: ->
    @game.hero.inventory.setPosition(@game.itemClicked)
    @inputEnabled = true
    @game.itemClicked = null
  
  update: ->
    if @inHand()
      @position.x = @game.input.activePointer.position.x + @game.camera.x
      @position.y = @game.input.activePointer.position.y + @game.camera.y

module.exports = Item
