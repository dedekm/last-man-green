Hero = require './hero.coffee'
Item = require './item.coffee'
Combinations = require './combinations.coffee'

preload = ->
  g.load.bitmapFont(
    'default',
    'fonts/carrier_command.png',
    'fonts/carrier_command.xml'
  )
  
  g.load.image('ball', 'images/ball.png')
  g.load.image('hero', 'images/hero.png')
  g.load.image('inventory', 'images/inventory.png')
  
  g.load.tilemap('map', 'tilemaps/test.csv', null, Phaser.Tilemap.CSV)
  g.load.image('tiles', 'images/tilemap.png')

create = ->
  g.canvas.oncontextmenu = (e) ->
     e.preventDefault()
  
  g.map = g.add.tilemap('map', 32, 32)
  g.map.addTilesetImage('tiles')
  
  g.layer = g.map.createLayer(0)
  g.layer.resizeWorld()
  g.map.setCollisionBetween(0, 9)
  
  inventory = g.add.sprite(120, 430, 'inventory')
  inventory.fixedToCamera = true
  inventory.inputEnabled = true
  inventory.events.onInputDown.add( (inventory, pointer) ->
    if pointer.leftButton.isDown
      if @game.itemClicked && @game.itemClicked.inHand()
        @game.hero.inventory.setPosition(@game.itemClicked)
        @game.itemClicked.inputEnabled = true
        @game.itemClicked = null
  , this)
  
  ball = new Item(g, 150, 250, 'ball')
  ball.anchor.set(0.5,0.5)
  ball.comment = 'Nice ball.'
  g.add.existing(ball)
  
  ball = new Item(g, 250, 250, 'ball')
  ball.anchor.set(0.5,0.5)
  ball.comment = 'Other nice ball.'
  g.add.existing(ball)
  
  g.hero = new Hero(g, g.camera.width / 2, g.camera.height / 2, 'hero')
  g.hero.body.setSize(64, 64)
  g.hero.anchor.set(0.5,0.5)
  g.add.existing(g.hero)
  
  g.input.onDown.add click

heroExits = 'none'
update = ->
  if heroExits == 'right' && g.hero.x > (g.camera.x + g.camera.width) - g.hero.body.width / 2
    g.camera.x += g.camera.width
    g.hero.stop()
    g.hero.x += g.hero.body.width / 2
    heroExits = false
  else if heroExits == 'left' && g.hero.x < g.camera.x + g.hero.body.width / 2
    g.camera.x -= g.camera.width
    g.hero.stop()
    g.hero.x -= g.hero.body.width / 2
    heroExits = false
  
  g.physics.arcade.collide g.hero, g.layer, (hero, wall) ->
    if hero.body.blocked.up || hero.body.blocked.down
      g.hero.target = { x: g.hero.target.x, y: g.hero.position.y }
      g.physics.arcade.moveToXY(g.hero, g.hero.target.x, g.hero.target.y, 250)
    if hero.body.blocked.right || hero.body.blocked.left
      g.hero.target = { x: g.hero.position.x, y: g.hero.target.y }
      g.physics.arcade.moveToXY(g.hero, g.hero.target.x, g.hero.target.y, 250)

click = (pointer) ->
   unless 120 < pointer.position.x < 640 - 120 && pointer.position.y > 430
    if g.itemClicked && g.itemClicked.inInventory()
      # FIXME: drop item
    else
      g.hero.moveToXY(
        x: g.camera.x + pointer.position.x
        y: g.camera.y + pointer.position.y
      )
  
      g.itemClicked = null if g.itemClicked && !g.itemClicked.inInventory()
  
      if g.hero.target.x > (g.camera.x + g.camera.width) - g.hero.body.width / 2
        heroExits = 'right'
      else if g.hero.target.x < g.camera.x + g.hero.body.width / 2
        heroExits = 'left'
  
g = new (Phaser.Game)(640, 480, Phaser.AUTO, 'ld41',
  preload: preload
  create: create
  update: update
)
g.combinations = new Combinations
