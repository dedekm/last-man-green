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
      
      bomb = @game.bombs[0]
      @game.add.existing(bomb)
      bomb.fly(70, -65, bomb.y + 50)
      
      bomb = @game.bombs[1]
      @game.add.existing(bomb)
      bomb.fly(-70, -65, bomb.y + 50)
      
      hero.comment 'GOAL!'
    
module.exports = Mechanics
  
