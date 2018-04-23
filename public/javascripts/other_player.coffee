Ball = require './ball.coffee'

class OtherPlayer extends Phaser.Sprite
  constructor: (game, key, frame) ->
    super game, -16, 128, key, frame
    @speed = 85

    @animations.add('run', [0..7], 9, true)
    @animations.add('fall', [8..22], 9)
    
    @game.physics.enable(this, Phaser.Physics.ARCADE)
    # @body.setSize(20, 12, 6, 35)
    @anchor.set(0.5,0.9)
    
    @inputEnabled = true
    @events.onInputDown.add( (item, pointer) ->
      if pointer.rightButton.isDown
        @game.hero.comment @comment
    , this)
    
    @comment = 'Roberto something...'
    
    @ball = new Ball(@game, 0, 0, 'ball')
    @ball.anchor.set(0.5, 0.5)
    @ball.comment = 'Nice ball.'
    @game.physics.enable(@ball, Phaser.Physics.ARCADE)
  
  run: ->
    @ball.position.set(@x + @ball.width, @y - @ball.width / 2)
    @game.add.existing(@ball)
    @animations.play('run', 9, true)
    @game.physics.arcade.moveToXY(@ball, @ball.x + @game.camera.width, @ball.y, @speed + 10)
    @game.physics.arcade.moveToXY(this, @x + @game.camera.width, @y, @speed)
    @game.time.events.add(Phaser.Timer.SECOND * 0, ->
      @events.onAnimationLoop.add(  ->
        @events.onAnimationLoop.removeAll()
        @fall()
      , this)
    , this)
  
  fall: ->
    @animations.play('fall', 9)
    @events.onAnimationComplete.add( ->
      @body.velocity.setTo(0, 0)
    , this)
    
module.exports = OtherPlayer
