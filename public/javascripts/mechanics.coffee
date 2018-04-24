class Mechanics extends Object
  # Use like this:
  #
  # TILEMAP_ITEMS:
  #   20: 'This is wall.'
  #   21: 20
  #   22: 20
  #   23: 'This is grass.'
  TILEMAP_ITEMS:
    68: 'Dead bird probably.'
    91: 'Oh, looks feminine.'
    89: "A bone. Doesnt look feminine."
    103: 'Sponsor, I guess.'
    37: 'Somebody beefy leaned on this railing.'
    102: 'Just a picture.'
  
  ITEMS:
    ball: 'Nice ball.'
    gate: 'What is this?'
    other_player: 'Roberto something...'
  
  VALID_COMBINATIONS:
    ball_gate: 'goal'
    
  COMBINATIONS_WITH_COMMENTS:
    ball_ball: 'Ball on ball, cool!'
  
  INVALID_COMBINATIONS: [
    "I don't think so!",
    "This is not posible!"
  ]

  constructor: (game) ->
    super()
    @game = game
    
  check: (first, second) ->
    result = @VALID_COMBINATIONS["#{first.id}_#{second.id}"]
    if result
      this[result](first, second)
      null
    else
      result = @COMBINATIONS_WITH_COMMENTS["#{first.id}_#{second.id}"]
      result ||= @COMBINATIONS_WITH_COMMENTS["#{second.id}_#{first.id}"]
      result ||= @INVALID_COMBINATIONS[parseInt(@INVALID_COMBINATIONS.length * Math.random())]
  
  goal: (ball, gate) ->
    position = gate.position.clone()
    if gate.flipped
      position.x -= 16 * 2.5
      ball.qf = 16
    else
      position.x += 16 * 2.5
      ball.qf = -16
    
    @game.hero.moveToItem position, (hero, ball) ->
      hero.freeze()
      hero.game.world.sendToBack(ball)
      hero.game.world.moveUp(ball)
      ball.fixedToCamera = false
      ball.state = 'used'
      ball.position.x = hero.x + ball.qf
      ball.position.y = hero.y
      ball.body.drag.x = 20
      hero.game.physics.arcade.moveToXY(ball, ball.x + ball.qf * 2, ball.y, 20)
      if ball.qf == 16
        ball.move(-1)
      else
        ball.move(1)
      
      @game.time.events.add(Phaser.Timer.SECOND * 0.5, throwBomb, this)
      
throwBomb = ->
  if @game.bombs.length > 0
    i = @game.bombs.length
    bomb = @game.bombs.shift()
    bomb.position.set(
      @game.camera.x - 20 - Math.random() * 10 * i,
      @game.camera.y - Math.random() * 20 + 15 * i
    )
    @game.add.existing(bomb)
    bomb.fly(65, -55 - 40 * Math.random(), bomb.y + 50)
    
    i = @game.bombs.length
    bomb = @game.bombs.shift()
    bomb.scale.x = -1
    bomb.position.set(
      @game.camera.x + @game.camera.width + 20 + Math.random() * 10 * i,
      @game.camera.y + Math.random() * 20 + 15 * i
    )
    @game.add.existing(bomb)
    bomb.fly(-65, -55 - 40 * Math.random(), bomb.y + 50)
    
    @game.time.events.add(Phaser.Timer.SECOND * (0.5 * 0.5 * Math.random()), throwBomb, this)
  else
    @game.time.events.add( Phaser.Timer.SECOND * 1, ->
      @game.effect = @game.add.graphics(@game.camera.x, @game.camera.y)
      blick @game, 0
    , this)
blick = (game, n, time = 0.3) ->
  n+=1
  game.effect.beginFill(colors[n % colors.length])
  game.effect.drawRect(0, 0, game.camera.width, game.camera.height)
  game.time.events.add(Phaser.Timer.SECOND * time, ->
    if n < 4
      game.effect.clear()
      game.time.events.add(Phaser.Timer.SECOND * 0.6, ->
        blick(game, n)
      , this)
    else
      unless game.titles
        game.titles = true
        for text, i in ['Thanks for playing', null, 'Martin Dedek', 'Viktor Dedek', 'Jiri Honzel']
          continue unless text
          title = game.add.bitmapText(
            Math.round(game.camera.x + game.camera.width / 2 - (text.length * 7 / 2)),
            Math.round(game.camera.y + 40 + 7 * i),
            'default-black', text, 6
          )
          game.canvas.classList.remove('frozen')
      blick(game, n, 0.8)
  , this)
colors = [0xffffff, 0xddffff, 0xff22ff, 0xffffff, 0xffff88, 0xffeeff, 0xffeeaa]

module.exports = Mechanics
