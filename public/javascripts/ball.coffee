Item = require './item.coffee'

class Ball extends Item
  update: ->
    super()
    
    if @body.speed > 0
      if Phaser.Math.radToDeg(@body.angle) > 90
        @stop(-1) if @x < @game.camera.x
      else
        @stop(1) if @x > @game.camera.x + @game.camera.width
      
  stop: (flipped) ->
    @body.velocity.setTo(0, 0)
    @position.x = @game.camera.position.x + (@game.camera.width - 16) * 1.5 * flipped
      
module.exports = Ball
