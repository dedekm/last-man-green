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
    item.position.x = 150 + index * 50
    item.position.y = 455
    item.fixedToCamera = true
    item.state = 'inventory'
     
module.exports = Inventory
    
  
