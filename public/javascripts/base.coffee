Hero = require './hero.coffee'
Item = require './item.coffee'
Bomb = require './bomb.coffee'
OtherPlayer = require './other_player.coffee'
Mechanics = require './mechanics.coffee'

preload = ->
  g.load.bitmapFont(
    'default',
    'fonts/carrier_command.png',
    'fonts/carrier_command.xml'
  )
  g.load.bitmapFont(
    'default-black',
    'fonts/carrier_command_black.png',
    'fonts/carrier_command.xml'
  )
  
  g.load.spritesheet('ball', 'images/ball_10x10.png', 10, 10)
  g.load.image('gate', 'images/gate_32x96.png')
  g.load.spritesheet('bomb_red', 'images/bomb_red_15x10.png', 15, 10)
  g.load.spritesheet('bomb_white', 'images/bomb_white_15x10.png', 15, 10)
  g.load.spritesheet('hero', 'images/hero_32x52.png', 32, 52)
  g.load.spritesheet('other_player', 'images/falling_52x52.png', 52, 52)
  
  g.load.tilemap('map', 'tilemaps/tilemap.csv', null, Phaser.Tilemap.CSV)
  g.load.image('tiles', 'images/stadion_tileset_16x16.png')
  
  g.load.audio('run-grass', 'audio/run_grass.mp3')
  # g.load.audio('run-wet', 'audio/run_wet.mp3')
  g.load.audio('final', 'audio/final.mp3')
  g.load.audio('end', 'audio/end.mp3')
  g.load.audio('ambient', 'audio/ambient.mp3')

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
  g.map.setCollision(79)
  
  g.otherPlayer = new OtherPlayer(g, 'other_player')
  
  g.camera.x = 3 * (g.camera.width - 16)
  g.camera.y = 3 * g.camera.height
  g.hero = new Hero(g, 3.5 * g.camera.width - 2 * 16, 3.6 * g.camera.height, 'hero')
  g.add.existing(g.hero)
  
  g.bombs = []
  for i in [0..2]
    g.bombs.push new Bomb(@game, 0, 0, 'bomb_white')
    g.bombs.push new Bomb(@game, 0, 0, 'bomb_red')
    
    
    g.bombs.shuffle
  for bomb in g.bombs
    bomb.animations.add('burn', [1,2], 5, true)

  @game.physics.enable(g.bombs, Phaser.Physics.ARCADE)
  g.add.existing(g.bombs[0])
  
  y = g.camera.height * 2.5
  gate = new Item(@game, 48, y, 'gate')
  gate.anchor.set(0, 0.5)
  gate.state = 'unpickable'
  gate.flipped = false
  g.add.existing(gate)
  
  gate = new Item(@game, g.world.width - 48, y, 'gate')
  gate.scale.x = -1
  gate.anchor.set(0, 0.5)
  gate.state = 'unpickable'
  gate.flipped = true
  gate.comment = 'What is this?'
  g.add.existing(gate)
  g.input.onDown.add click
  
  createInventory()
  
  g.endSound = g.add.audio('end')
  g.endSound.addMarker('bombs', 0, 18)
  g.endSound.addMarker('vuvuzelas', 18, 54.5)
  
  g.backgroundSound = g.add.audio('ambient', 1, true)
  g.sound.setDecodedCallback(g.backgroundSound, ->
    g.backgroundSound.play()
  , this)
  
  help = document.createElement('div')
  help.classList.add('help')
  help.innerHTML+='left click = use / right click = inspect'
  document.body.appendChild(help)

heroExits = 'none'
update = ->
  if heroExits == 'right' && g.hero.x > g.camera.x + g.camera.width - g.hero.body.height
    unless g.camera.x == g.world.width - g.camera.width
      g.camera.x += g.camera.width - 16
      g.hero.moveToXY(
        x: g.camera.x + 28
        y: g.hero.target.y
      )
      travelled = true
    else
      g.hero.stop()
  else if heroExits == 'left' && g.hero.x < g.camera.x + g.hero.body.height + 16
    unless g.camera.x == 0
      g.camera.x -= g.camera.width - 16
      g.hero.moveToXY(
        x: g.camera.x + g.camera.width - 16
        y: g.hero.target.y
      )
      travelled = true
    else
      g.hero.stop()
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
    
    if g.hero.travelled >= 3 && g.otherPlayer.position.y == 0
      return if g.camera.x == 0 || g.camera.x == g.world.width - g.camera.width
      
      g.hero.freeze()
      
      if g.camera.y == 0
        y = g.camera.position.y + g.camera.height / 4 * 3
      else
        y = g.camera.position.y + g.camera.height / 2
      
      g.otherPlayer.add(
        32,
        y,
        g.hero.position.x + g.camera.x < g.camera.x + g.camera.width / 2
      )
  
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
  unless g.hero.isFrozen()
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
      else
        g.hero.commentTile(g.map.getTileWorldXY(g.camera.x + pointer.x, g.camera.y + pointer.y).index)

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
g.mechanics = new Mechanics(g)
