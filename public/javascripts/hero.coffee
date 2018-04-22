class Hero extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @speed = 250
    @game.physics.enable(this, Phaser.Physics.ARCADE)
    
  update: ->
    if @target && @position.distance(@target) < 10
      @stop()
      
  moveToXY: (target) ->
    @target = target
    @game.physics.arcade.moveToXY(this, @target.x, @target.y, @speed)
  
  stop: ->
    @body.velocity.setTo(0, 0)

module.exports = Hero
