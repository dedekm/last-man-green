Inventory = require './inventory.coffee'

class Hero extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @speed = 80
    @inventory = new Inventory(game)
    @game.physics.enable(this, Phaser.Physics.ARCADE)

    @animations.add('left-down', [0..7], 9, true)
    @animations.add('left-up', [8..15], 9, true)
    @animations.add('up', [16..23], 9, true)
    @animations.add('right-up', [24..31], 9, true)
    @animations.add('right-down', [32..39], 9, true)
    @animations.add('down', [40..47], 9, true)
    @animations.add('idle', [48..55], 9, true)

    @body.setSize(32, 12, 0, 40)
    @anchor.set(0.5,1)
    
  update: ->
    if @body.speed > 0
      angle = Phaser.Math.radToDeg @body.angle
      if -180 <= angle < -100
        animation = 'left-up'
      else if -100 <= angle < -80
        animation = 'up'
      else if -80 <= angle < 0
        animation = 'right-up'
      else if 0 <= angle < 80
        animation = 'right-down'
      else if 80 <= angle < 115
        animation = 'down'
      else if 115 <= angle <= 180
        animation = 'left-down'
      
      @game.hero.animations.play(animation, 9, true) if animation
    else
      @game.hero.animations.stop(null, true)
      
    if @target && @position.distance(@target) < 5
      @stop()

    if @game.itemClicked && @game.itemClicked.pickable() && @position.distance(@game.itemClicked.position) < 10
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
