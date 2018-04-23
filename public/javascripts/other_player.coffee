Ball = require './ball.coffee'

class OtherPlayer extends Phaser.Sprite
  constructor: (game, key, frame) ->
    super game, 0, 0, key, frame
    @speed = 85

    @animations.add('run', [0..4], 9)
    @animations.add('fall', [8..22], 9)
    
    @game.physics.enable(this, Phaser.Physics.ARCADE)
    # @body.setSize(20, 12, 6, 35)
    @anchor.set(0.5,0.9)
    
    @inputEnabled = true
    @events.onInputDown.add( (item, pointer) ->
      if pointer.rightButton.isDown
        @game.hero.comment @comment
    , this)
        
    @ball = new Ball(@game, 0, 0, 'ball')
    @ball.anchor.set(0.5, 0.5)
    @game.physics.enable(@ball, Phaser.Physics.ARCADE)
  
  add: (x, y, flipped = false) ->
    flipped = if !flipped then 1 else -1
    
    if flipped == -1
      x = @game.camera.x + @game.camera.width + x
    else
      x = @game.camera.x - x
    @position.set(
      x,
      y
    )
    @scale.x = flipped
    @game.add.existing(this)
    @ball.position.set(@x + 14 * flipped, @y - @ball.width / 2)
    @game.add.existing(@ball)
    @game.world.bringToTop(@game.hero)
    
    @run(flipped)
  
  run: (flipped) ->
    @game.physics.arcade.moveToXY(@ball, @ball.x + @game.camera.width * flipped, @ball.y, @speed + 10)
    @game.physics.arcade.moveToXY(this, @x + @game.camera.width * flipped, @y, @speed)
    @fall()
  
  fall: ->
    @animations.play('fall', 9)
    @events.onAnimationComplete.add( ->
      @body.velocity.setTo(0, 0)
    , this)
    
module.exports = OtherPlayer
