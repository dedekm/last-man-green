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
    
    if @clicked && @position.distance(@clicked) < 40
      @stop()
      @pickUp(@clicked)
      @clicked = null
      
  moveToXY: (target, clicked) ->
    @target = target
    @game.physics.arcade.moveToXY(this, @target.x, @target.y, @speed)
    @clicked = clicked
    
  pickUp: (item) ->
    @inventory.addItem item
    
  stop: ->
    @body.velocity.setTo(0, 0)
  
  comment: (text) ->
    comment = @game.add.bitmapText(@position.x - text.length * 12, @position.y - @body.height, 'default', text, 22)
    @game.time.events.add(Phaser.Timer.SECOND * 2, ->
      comment.destroy()
    , this);

module.exports = Hero
