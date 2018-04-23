Item = require './item.coffee'

class Ball extends Item
  update: ->
    super()
    
    if @body.speed > 0 && @x > @game.camera.x + @game.camera.width
      @body.velocity.setTo(0, 0)
      @position.set(
        @game.camera.position.x + @game.camera.width * 1.5,
        @y
      )
      
module.exports = Ball
