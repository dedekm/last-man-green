Inventory = require './inventory.coffee'

class Hero extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @speed = 250
    @inventory = new Inventory(game)
    @game.physics.enable(this, Phaser.Physics.ARCADE)
    
  update: ->
    if @target && @position.distance(@target) < 10
      @stop()

    if @game.itemClicked && @game.itemClicked.pickable() && @position.distance(@game.itemClicked.position) < 40
      @stop()
      @pickUp(@game.itemClicked)
      
  moveToXY: (target) ->
    @target = target
    @game.physics.arcade.moveToXY(this, @target.x, @target.y, @speed)
    
  pickUp: (item) ->
    @inventory.addItem item
    @game.itemClicked = null
    
  stop: ->
    @body.velocity.setTo(0, 0)
  
  comment: (text) ->
    comment = @game.add.bitmapText(@position.x - text.length * 12, @position.y - @body.height, 'default', text, 22)
    @game.time.events.add(Phaser.Timer.SECOND * 2, ->
      comment.destroy()
    , this)

module.exports = Hero
