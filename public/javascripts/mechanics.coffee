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
    @game.hero.moveToItem gate, (hero) ->
      hero.comment 'GOAL!'
    
module.exports = Mechanics
  
