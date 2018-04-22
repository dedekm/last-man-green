class Inventory extends Object
  constructor: (game) ->
    super()
    @game = game
    @items = []
    
  addItem: (item) ->
    @items.push(item)
    item.position.x = 150 + (@items.length - 1) * 50
    item.position.y = 455
    item.fixedToCamera = true
    item.pickable = false
     
module.exports = Inventory
    
  
