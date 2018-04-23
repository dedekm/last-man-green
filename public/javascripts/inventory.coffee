class Inventory extends Object
  constructor: (game) ->
    super()
    @game = game
    @items = []
    
  addItem: (item) ->
    @items.push(item)
    @setPosition(item)
    
  
  setPosition: (item) ->
    index = @items.indexOf item
    @game.world.bringToTop(item)
    item.position.x = 8
    item.position.y = 8 + index * 16
    item.fixedToCamera = true
    item.state = 'inventory'
     
module.exports = Inventory
    
  
