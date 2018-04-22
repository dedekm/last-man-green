COMBINATIONS = {
  ball_ball: 'Ball on ball, cool!'
}

class Combinations extends Object
  constructor: (game) ->
    super()
    @game = game
    @list = COMBINATIONS
    
  check: (first, second) ->
    result = @list["#{first.id}_#{second.id}"]
    result ||= @list["#{second.id}_#{first.id}"]
    result

module.exports = Combinations
  
