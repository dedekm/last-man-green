Hero = require './hero.coffee'
Item = require './item.coffee'
Combinations = require './combinations.coffee'

preload = ->
  g.load.bitmapFont(
    'default',
    'fonts/carrier_command.png',
    'fonts/carrier_command.xml'
  )
  
  g.load.spritesheet('ball', 'images/ball_10x10.png', 10, 10)
  g.load.spritesheet('hero', 'images/hero_32x52.png', 32, 52)
  g.load.image('inventory', 'images/inventory.png')
  
  g.load.tilemap('map', 'tilemaps/tilemap.csv', null, Phaser.Tilemap.CSV)
  g.load.image('tiles', 'images/stadion_tileset_16x16.png')

create = ->
  g.canvas.oncontextmenu = (e) ->
     e.preventDefault()
  
  g.scale.scaleMode = Phaser.ScaleManager.USER_SCALE
  g.scale.setUserScale(3, 3)
  g.renderer.renderSession.roundPixels = true
  Phaser.Canvas.setImageRenderingCrisp(g.canvas)
  
  g.map = g.add.tilemap('map', 16, 16)
  g.map.addTilesetImage('tiles')
  
  g.layer = g.map.createLayer(0)
  g.layer.resizeWorld()
  g.map.setCollisionBetween(0, 57)
  
  g.ball = new Item(g, 128, 128, 'ball')
  g.ball.anchor.set(0.5,0.5)
  g.ball.comment = 'Nice ball.'
  
  g.hero = new Hero(g, 100, 120, 'hero')
  g.add.existing(g.hero)
  
  g.input.onDown.add click
  
  createInventory()

heroExits = 'none'
update = ->
  if heroExits == 'right' && g.hero.x > g.camera.x + g.camera.width - g.hero.body.height
    g.camera.x += g.camera.width - 16
    g.hero.moveToXY(
      x: g.camera.x + 28
      y: g.hero.target.y
    )
    travelled = true
  else if heroExits == 'left' && g.hero.x < g.camera.x + g.hero.body.height + 16
    g.camera.x -= g.camera.width - 16
    g.hero.moveToXY(
      x: g.camera.x + g.camera.width - 16
      y: g.hero.target.y
    )
    travelled = true
  else if heroExits == 'up' && g.hero.y < g.camera.y + g.hero.body.height
    g.camera.y -= g.camera.height
    g.hero.moveToXY(
      x: g.hero.target.x
      y: g.camera.y + g.camera.height
    )
    travelled = true
  else if heroExits == 'down' && g.hero.y > g.camera.y + g.camera.height - g.hero.body.height
    g.camera.y += g.camera.height
    g.hero.moveToXY(
      x: g.hero.target.x
      y: g.camera.y + 16
    )
    travelled = true
  
  if travelled
    heroExits = null
    g.hero.travelled +=1
    
    if g.hero.travelled >= 3
      if g.camera.y == 0
        y = g.camera.position.y + g.camera.height / 4 * 3
      else
        y = g.camera.position.y + g.camera.height / 2
      g.ball.position.set(
        g.camera.position.x + g.camera.width / 2,
        y
      )
      g.add.existing(g.ball)
  
  g.physics.arcade.collide g.hero, g.layer, (hero, wall) ->
    if hero.body.blocked.up || hero.body.blocked.down
      g.hero.moveToXY(
        x: g.hero.target.x
        y: g.hero.position.y
      )
    if hero.body.blocked.right || hero.body.blocked.left
      g.hero.moveToXY(
        x: g.hero.position.x
        y: g.hero.target.y
      )

click = (pointer) ->
  if pointer.leftButton.isDown && pointer.position.x > 16
    if g.itemClicked && g.itemClicked.inInventory()
      # FIXME: drop item
    else
      g.hero.moveToXY(
        x: g.camera.x + pointer.position.x
        y: g.camera.y + pointer.position.y
      )
      
      g.itemClicked = null if g.itemClicked && !g.itemClicked.inInventory()
      
      if g.hero.target.x > g.camera.x + g.camera.width - g.hero.body.height
        heroExits = 'right'
      else if g.hero.target.x < g.camera.x + g.hero.body.height + 16
        heroExits = 'left'
      else if g.hero.target.y < g.camera.y + g.hero.body.height
        heroExits = 'up'
      else if g.hero.target.y > g.camera.y + g.camera.height - g.hero.body.height
        heroExits = 'down'
      else
        heroExits = null
        
  else if pointer.rightButton.isDown
    if g.itemClicked && g.itemClicked.inHand()
      g.itemClicked.returnToInventory()

createInventory = ->
  graphics = g.add.graphics(100, 100)
  graphics.beginFill(0x333333)
  graphics.drawRect(0, 0, 16, g.camera.height)
  
  inventory = g.add.sprite(0, 0, graphics.generateTexture())
  inventory.fixedToCamera = true
  inventory.inputEnabled = true
  inventory.events.onInputDown.add( (inventory, pointer) ->
    if pointer.leftButton.isDown
      if g.itemClicked && g.itemClicked.inHand()
        g.hero.inventory.setPosition(g.itemClicked)
        g.itemClicked.inputEnabled = true
        g.itemClicked = null
  , this)
  
  graphics.destroy()

render = ->
    # g.debug.body(g.hero)

g = new (Phaser.Game)(720 / 3, 480 / 3, Phaser.AUTO, 'last-man-green',
  preload: preload
  create: create
  update: update
  render: render
)
g.combinations = new Combinations
