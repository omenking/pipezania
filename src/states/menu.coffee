red  = null
blue = null

g = null

part = 1
rev = false

per  = 0

tick = null

cal_p1 = (n)=>
  p = if per >= 100 then 100 else per
  p = 0 if p < 0
  v = (n / 100) * p
cal_p2 = (n)=>
  p =
  if      per >= 200 then 100
  else if per >= 100 && per < 200 then per-100
  else
    0
  v = (n / 100) * p
cal_p3 = (n)=>
  p =
  if      per >= 300 then 100
  else if per >= 200 && per < 300 then per-200
  else
    0
  v = (n / 100) * p
cal_p4 = (n)=>
  p =
  if      per >= 400 then 100
  else if per >= 300 && per < 400 then per-300
  else
    0
  v = (n / 100) * p


animate = =>
  per += 10
  g.clear()
  g.lineStyle 8, 0xffd900
  switch part
    when 1 then animate1()
    when 2 then animate2()
    when 3 then animate3()
    when 4 then animate4()
  if per >= 400
    if rev
      if part is 4
        part = 1
      else
        part++
    rev = !rev
    per = 0

animate1 = =>
  yoff = 7*64

  v = cal_p1(90)
  if rev
    g.arc 0, yoff+64, 32, game.math.degToRad(270+v), game.math.degToRad(360), false
  else
    g.arc 0, yoff+64, 32, game.math.degToRad(270), game.math.degToRad(270+v), false

  v = cal_p2(90)
  if rev
    g.arc 64, yoff+64, 32, game.math.degToRad(180-v), game.math.degToRad(90), true
  else
    g.arc 64, yoff+64, 32, game.math.degToRad(180), game.math.degToRad(180-v), true

  v = cal_p3(64)
  if rev
    g.moveTo 128 , 64+32+yoff
    g.lineTo 64+v, 64+32+yoff
  else
    g.moveTo 64  , 64+32+yoff
    g.lineTo 64+v, 64+32+yoff

  v = cal_p4(90)
  if rev
    g.arc 128, 128+yoff, 32, game.math.degToRad(270+v), game.math.degToRad(360), false
  else
    g.arc 128, 128+yoff, 32, game.math.degToRad(270), game.math.degToRad(270+v), false

animate2 = =>
  xoff = 9*64
  yoff = 7*64

  v = cal_p1(64)
  if rev
    g.moveTo xoff+32, yoff+128-v
    g.lineTo xoff+32, yoff+64
  else
    g.moveTo xoff+32, yoff+128
    g.lineTo xoff+32, yoff+128-v

  v = cal_p2(90)
  if rev
    g.arc xoff+64, yoff+64, 32, game.math.degToRad(180+v), game.math.degToRad(270), false
  else
    g.arc xoff+64, yoff+64, 32, game.math.degToRad(180), game.math.degToRad(180+v), false

  v = cal_p3(64)
  if rev
    g.moveTo xoff+128 , 32+yoff
    g.lineTo xoff+64+v, 32+yoff
  else
    g.moveTo xoff+64  , 32+yoff
    g.lineTo xoff+64+v, 32+yoff

  v = cal_p4(64)
  if rev
    g.moveTo xoff+64+128 , 32+yoff
    g.lineTo xoff+64+64+v, 32+yoff
  else
    g.moveTo xoff+64+64  , 32+yoff
    g.lineTo xoff+64+64+v, 32+yoff


animate3 = =>
  xoff = 8*64

  v = cal_p1(90)
  if rev
    g.arc xoff+128+64, 0, 32, game.math.degToRad(v), game.math.degToRad(90), false
  else
    g.arc xoff+128+64, 0, 32, game.math.degToRad(0), game.math.degToRad(v), false

  v = cal_p2(64)
  if rev
    g.moveTo xoff+128  , 32
    g.lineTo xoff+128+64-v, 32
  else
    g.moveTo xoff+128+64  , 32
    g.lineTo xoff+128+64-v, 32

  v = cal_p3(64)
  if rev
    g.moveTo xoff+64   , 32
    g.lineTo xoff+128-v, 32
  else
    g.moveTo xoff+128  , 32
    g.lineTo xoff+128-v, 32

  v = cal_p4(90)
  if rev
    g.arc xoff+64, 0, 32, game.math.degToRad(90+v), game.math.degToRad(180), false
  else
    g.arc xoff+64, 0, 32, game.math.degToRad(90), game.math.degToRad(90+v), false

animate4 = =>
  v = cal_p1(90)
  if rev
    g.arc 128, 0, 32, game.math.degToRad(v), game.math.degToRad(90), false
  else
    g.arc 128, 0, 32, game.math.degToRad(0), game.math.degToRad(v), false

  v = cal_p2(64)
  if rev
    g.moveTo 64  , 32
    g.lineTo 128-v, 32
  else
    g.moveTo 128  , 32
    g.lineTo 128-v, 32

  v = cal_p3(90)
  if rev
    g.arc 64, 64, 32, game.math.degToRad(180), game.math.degToRad(270-v), false
  else
    g.arc 64, 64, 32, game.math.degToRad(270-v), game.math.degToRad(270), false

  v = cal_p4(90)
  if rev
    g.arc 0, 64, 32, game.math.degToRad(v), game.math.degToRad(90), false
  else
    g.arc 0, 64, 32, game.math.degToRad(0), game.math.degToRad(v), false



start_adventure_onclick = ->
  _d.mode = 'adventure'
  game.state.start 'levels'

start_time_onclick = ->
  _d.mode = 'time'
  game.state.start 'levels'

tween_red = =>
  tween = game.add.tween(red.scale)
  tween.to {x: 1.3, y: 1.3},250, Phaser.Easing.Linear.None
  tween.to {x: 1, y: 1}    ,250, Phaser.Easing.Linear.None
  tween.loop true
  tween.start()

tween_blue = =>
  tween = game.add.tween(blue.scale)
  tween.to {x: 1.3, y: 1.3},250, Phaser.Easing.Linear.None
  tween.to {x: 1, y: 1}    ,250, Phaser.Easing.Linear.None
  tween.loop true
  tween.start()

create = ->
  game.add.sprite 0 , 0 , 'menu'

  tick = game.time.now
  g = game.add.graphics 0, 0

  btn = game.add.button (4*64)+32, (4*64)+32, 'button_adventure', start_adventure_onclick, this, 0,0,0
  btn = game.add.button (4*64)+32, (5*64)+32, 'button_time'     , start_time_onclick     , this, 0,0,0

  tween = game.add

  red  = game.add.sprite (2*64)+32, (2*64)+32, 'jewel_red'
  blue = game.add.sprite (9*64)+32, (2*64)+32, 'jewel_blue'
  red.anchor.setTo  0.5, 0.5
  blue.anchor.setTo 0.5, 0.5

  tween_red()
  game.time.events.add(Phaser.Timer.SECOND * 0.25, tween_blue, this)

update = ->
  if (game.time.now - tick > 10)
    tick =  game.time.now
    animate()

_states.menu =
  create: create
  update: update
