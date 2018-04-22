class Hero extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @speed = 250
    @inventory = []
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
    @inventory.push item
    item.position.x = 50
    item.position.y = 400
    
  stop: ->
    @body.velocity.setTo(0, 0)

module.exports = Hero
