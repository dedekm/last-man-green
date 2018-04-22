class Item extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @inputEnabled = true
    @events.onInputDown.add( (ball) ->
      @game.itemClicked = ball if @pickable
    , this)
    @pickable = true

module.exports = Item
