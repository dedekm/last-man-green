preload = ->
  g.load.image('hero', 'images/hero.png')
  g.load.tilemap('map', 'tilemaps/test.csv', null, Phaser.Tilemap.CSV)
  g.load.image('tiles', 'images/tilemap.png')

create = ->
  g.map = g.add.tilemap('map', 32, 32)
  g.map.addTilesetImage('tiles')
  
  g.layer = g.map.createLayer(0)
  g.layer.resizeWorld()
  g.map.setCollisionBetween(0, 9)
  
  g.hero = g.add.sprite(g.world.centerX, g.world.centerY, 'hero')
  g.physics.enable(g.hero, Phaser.Physics.ARCADE)
  g.hero.body.setSize(64, 64);
  g.hero.anchor.set(0.5,0.5)

mouseDown = false
update = ->
  g.physics.arcade.collide g.hero, g.layer, (hero, wall) ->
    if hero.body.blocked.up || hero.body.blocked.down
      g.hero.target = { x: g.hero.target.x, y: g.hero.position.y }
      g.physics.arcade.moveToXY(g.hero, g.hero.target.x, g.hero.target.y, 250)
    
  if g.input.activePointer.isDown && !mouseDown
    g.hero.target = { x: g.input.mousePointer.position.x, y: g.input.mousePointer.position.y }
    g.physics.arcade.moveToXY(g.hero, g.hero.target.x, g.hero.target.y, 250)
    mouseDown = true
  
  if g.input.activePointer.isUp && mouseDown
    mouseDown = false
    
  if g.hero.target && g.hero.position.distance(g.hero.target) < 10
    g.hero.body.velocity.setTo(0, 0)

g = new (Phaser.Game)(800, 600, Phaser.AUTO, 'ld41',
  preload: preload
  create: create
  update: update
)
