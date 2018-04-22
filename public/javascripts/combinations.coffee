

class Combinations extends Object
  VALID: {
    ball_ball: 'Ball on ball, cool!'
  }
  
  INVALID: [
    "I don't think so!"
  ]

  constructor: (game) ->
    super()
    @game = game
    
  check: (first, second) ->
    result = @VALID["#{first.id}_#{second.id}"]
    result ||= @VALID["#{second.id}_#{first.id}"]
    result ||= @INVALID[parseInt(@BAD_COMBINATIONS.length * Math.random())]

module.exports = Combinations
  
