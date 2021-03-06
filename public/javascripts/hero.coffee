Inventory = require './inventory.coffee'

class Hero extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @speed = 75
    @inventory = new Inventory(game)
    @game.physics.enable(this, Phaser.Physics.ARCADE)
    @state = null
    @travelled = 0

    @animations.add('left-down', [0..7], 9, true)
    @animations.add('left-up', [8..15], 9, true)
    @animations.add('up', [16..23], 9, true)
    @animations.add('right-up', [24..31], 9, true)
    @animations.add('right-down', [32..39], 9, true)
    @animations.add('down', [40..47], 9, true)
    @animations.add('idle', [48..55], 9, true)
    
    @sounds = {
      'run-grass': @game.add.audio('run-grass', 1, true),
      # 'run-wet': @game.add.audio('run-wet', 1, true),
      'final': @game.add.audio('final')
    }
    @sounds['final'].addMarker('start', 0, 2.9)
    @sounds['final'].addMarker('goal', 2.9, 23)

    @body.setSize(20, 12, 6, 35)
    @anchor.set(0.5,0.9)
    
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
      
      @animations.play(animation, 9, true) if animation
    else
      @animations.stop(null, true)
      
    if @target && @position.distance(@target) < 5
      @stop()

    if @game.itemClicked && @game.itemClicked.pickable() && @position.distance(@game.itemClicked.position) < 10
      @stop()
      @pickUp(@game.itemClicked)
    
    if @itemUsedPosition && @position.distance(@itemUsedPosition) < 100
      unless @sounds['final'].isPlaying
        @sounds['final'].play('start')
    
    if @itemUsedPosition && @position.distance(@itemUsedPosition) < 10
      if @sounds['final'].currentTime < 3000
        @sounds['final'].stop()
        @sounds['final'].play('goal')
      
      @itemUsedCallback(this, @game.itemClicked)
      @itemUsedPosition = null
      @itemUsedCallback = null
      @itemClicked = null
      stop()
    
  moveToItem: (target, callback) ->
    @moveToXY(target)
    
    if callback
      @itemUsedPosition = target
      @itemUsedCallback = callback
    
  moveToXY: (target, speed) ->
    unless @isFrozen()
      @target = target
      @game.physics.arcade.moveToXY(this, @target.x, @target.y, speed || @speed)
      unless @soundPlaying && @soundPlaying == @sounds['run-grass']
        @soundPlaying = @sounds['run-grass']
        @soundPlaying.play()
      
      @game.time.events.add(Phaser.Timer.SECOND * 0.5, ->
        @moveToXY(@target, @speed + 20) if @body.speed > 0
      , this)
    
  pickUp: (item) ->
    @inventory.addItem item
    @game.itemClicked = null
    
  stop: ->
    @body.velocity.setTo(0, 0)
    if @soundPlaying
      @soundPlaying.stop()
      @soundPlaying = null
  
  comment: (text) ->
    length = text.length * 6
    x = Math.round(@position.x - length / 2)
    y = Math.round(@position.y - @height)
    
    # text out of screen
    if x < @game.camera.x + 16
      x = @game.camera.x + 18
    else if x + length > @game.camera.x + @game.camera.width
      x = @game.camera.x + @game.camera.width - length

    if y < @game.camera.y + 6
      y = @position.y + 6

    comment = @game.add.bitmapText( x, y, 'default', text, 5 )
    @state = 'commenting'
    
    @game.time.events.add(Phaser.Timer.SECOND * 2, ->
      comment.destroy()
      @state = null
    , this)
  
  commentCombination: (first, second) ->
    unless @state == 'commenting'
      text = @game.mechanics.check(first, second)
      @comment(text) if text
  
  commentItem: (item) ->
    unless @state == 'commenting'
      @comment(@game.mechanics.ITEMS[item.key])
    
  commentTile: (index) ->
    unless @state == 'commenting'
      text = @game.mechanics.TILEMAP_ITEMS[index]
      text = @game.mechanics.TILEMAP_ITEMS[text] if typeof text == 'number'
      @comment(text) if text
  
  freeze: () ->
    @state = 'frozen'
    @game.canvas.classList.add('frozen')

  unfreeze: () ->
    @state = null
    @game.canvas.classList.remove('frozen')
     
  isFrozen: ->
    @state == 'frozen'

module.exports = Hero
