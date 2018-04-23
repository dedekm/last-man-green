Item = require './item.coffee'

class Ball extends Item
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @animations.add('move-right', [0..11], 12, true)
    @animations.add('move-left', [11..0], 12, true)
    
  update: ->
    super()

    if @body.speed > 0
      if Phaser.Math.radToDeg(@body.angle) > 90
        @stop(-1) if @x < @game.camera.x
      else
        @stop(1) if @x > @game.camera.x + @game.camera.width
      
      if @body.speed < 1
        @animations.paused = true
        @body.velocity.setTo(0, 0)
  
  move: (flipped) ->
    if flipped == -1
      @animations.play('move-right')
    else
      @animations.play('move-left')
    
  stop: (flipped) ->
    @animations.paused = true
    @body.velocity.setTo(0, 0)
    @position.x = @game.camera.position.x + (@game.camera.width - 16) * 1.5 * flipped
      
module.exports = Ball
