Item = require './item.coffee'

class Bomb extends Item    
  update: ->
    if @isFlying() && @y >= @floor && Phaser.Math.radToDeg @body.angle > 0
      @body.velocity.y *= -1
      @body.drag.y += 10
      if @body.velocity.x == 0
        @body.velocity.set(0, 0)
        @state == 'used'
        @body.gravity.y = 0
        @body.drag.y = 0
        @body.drag.x = 0
      
  isFlying: ->
    @state == 'flying'
    
  fly: (x, y, floor) ->
    @animations.play('burn', 9, true)
    @body.gravity.y = 200
    @body.drag.y = 30
    @body.drag.x = 15
    @floor = floor
    @state = 'flying'
    @body.velocity.set(x, y)
    
module.exports = Bomb
