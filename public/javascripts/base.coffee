preload = ->
  g.load.image('hero', 'images/hero.png')

create = ->
  g.hero = g.add.sprite(g.world.centerX, g.world.centerY, 'hero');
  g.hero.anchor.set(0.5,0.5)
  g.physics.enable(g.hero, Phaser.Physics.ARCADE);

mouseDown = false
update = ->
  if g.input.activePointer.isDown && !mouseDown
    g.hero.target = { x: g.input.mousePointer.position.x, y: g.input.mousePointer.position.y }
    g.physics.arcade.moveToXY(g.hero, g.hero.target.x, g.hero.target.y, 400)
    mouseDown = true
  
  if g.input.activePointer.isUp && mouseDown
    mouseDown = false
    
  if g.hero.target && g.hero.position.distance(g.hero.target) < 10
    g.hero.body.velocity.setTo(0, 0);

g = new (Phaser.Game)(800, 600, Phaser.AUTO, 'ld41',
  preload: preload
  create: create
  update: update
)
