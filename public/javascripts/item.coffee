class Item extends Phaser.Sprite
  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @inputEnabled = true
    @events.onInputDown.add( (ball, pointer) ->
      if @pickable && pointer.leftButton.isDown
        @game.itemClicked = ball
      else if pointer.rightButton.isDown
        @game.hero.comment @comment
    , this)
    @comment = ''
    @pickable = true

module.exports = Item
