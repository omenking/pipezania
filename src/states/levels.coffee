btn_music = null
btn_sound = null

star_med = null
gem_med  = null

style =
  font: '18px Verdana'
  fill: '#fff'
  align: 'center'

style2 =
  font: '12px Verdana'
  fill: '#000'
  align: 'center'

style3 =
  font: '20px Verdana'
  fill: '#fff'
  align: 'center'

onclick = (level)->
  _d.level = level.i
  game.state.start 'play'

jewel_color = (i,kind)->
  if _d.level_status(i,kind)
    "jewel_#{kind}"
  else
    "jewel_blank"


level_locked = (level,i)->
  if i >= 17
    level.frame = 3
    count = _d.needed_to_unlock(i)
  else
    level.frame = 1
    count = _d.needed_to_unlock(i)

  txt = game.make.text 50,72, count, style2
  txt.anchor.setTo 0.5, 0.5
  level.addChild txt


tween_star = =>
  tween = game.add.tween(star_med.scale)
  tween.to {x: 1.07, y: 1.07},250, Phaser.Easing.Linear.None
  tween.to {x: 1, y: 1}    ,250, Phaser.Easing.Linear.None
  tween.loop true
  tween.start()

tween_gem = =>
  tween = game.add.tween(gem_med.scale)
  tween.to {x: 1.07, y: 1.07},250, Phaser.Easing.Linear.None
  tween.to {x: 1, y: 1}    ,250, Phaser.Easing.Linear.None
  tween.loop true
  tween.start()

level_unlocked = (level,i)->
  level.frame = 0
  inline = 30
  red   = game.make.sprite inline        , 68, jewel_color(i, 'red')
  green = game.make.sprite (128/2)-3     , 68, jewel_color(i, 'green')
  blue  = game.make.sprite 128-(inline+4), 68, jewel_color(i, 'blue')

  scale = 0.7
  red.scale.setTo   scale, scale
  green.scale.setTo scale, scale
  blue.scale.setTo  scale, scale

  anchor = 0.5
  red.anchor.setTo   anchor, anchor
  green.anchor.setTo anchor, anchor
  blue.anchor.setTo  anchor, anchor

  txt = game.make.text 0,0, "#{i+1}", style
  txt.anchor.setTo 0.5, 0.5
  txt.x = level.width / 2
  txt.y = (level.height / 2) - 14


  if _d.level_status(i,'red')   &&
     _d.level_status(i,'green') &&
     _d.level_status(i,'blue')
    level.frame = 2
    txt.fill = '#000'

  level.addChild txt

  level.i = i
  level.inputEnabled = true
  level.events.onInputDown.add onclick, this

  level.addChild red
  level.addChild blue
  level.addChild green

onclick_sound = =>
  if btn_sound.frame is 0
    btn_sound.frame = 1
    _d.set_sound false
  else
    btn_sound.frame = 0
    _d.set_sound true

onclick_music = =>
  if btn_music.frame is 2
    btn_music.frame = 3
    _d.set_music false
  else
    btn_music.frame = 2
    _d.set_music true

create = ->
  game.stage.backgroundColor = '#1c1c1c'

  group = game.add.group()
  group.createMultiple 20, 'levels', 0, true
  group.align 5, 4, 128, 96

  group.x = (game.world.width  / 2) - (group.width  / 2)
  group.y = (game.world.height / 2) - (group.height / 2)

  select_level = game.add.sprite  0, 0, 'select_level'
  select_level.anchor.setTo 0.5, 0.5
  select_level.y = 64
  select_level.x = game.world.width / 2

  btn_music = game.add.sprite  620, 512, 'audio_buttons'
  btn_music.frame = if _d.get_music() then 2 else 3
  btn_music.anchor.setTo 0.5, 0.5
  btn_music.inputEnabled = true
  btn_music.events.onInputDown.add onclick_music, this

  btn_sound = game.add.sprite 680, 512, 'audio_buttons'
  btn_sound.frame = if _d.get_sound() then 0 else 1
  btn_sound.anchor.setTo 0.5, 0.5
  btn_sound.inputEnabled = true
  btn_sound.events.onInputDown.add onclick_sound, this

  g_gem = game.add.group()
  i = _d.gem_count()
  txt = game.make.text 0,0, i, style3
  txt.anchor.setTo 0.5, 0.5
  gem_med = game.add.sprite -50, -18, 'jewel_med'
  g_gem.addChild gem_med
  g_gem.addChild txt
  g_gem.x = 120
  g_gem.y = 512

  g_star = game.add.group()
  i = _d.star_count()
  txt = game.make.text 0,0, i, style3
  txt.anchor.setTo 0.5, 0.5
  star_med = game.add.sprite -50, -20, 'star_med'
  g_star.addChild star_med
  g_star.addChild txt
  g_star.x = 220
  g_star.y = 512


  for level,i in group.children
    if _d.is_unlocked(i)
      level_unlocked level,i
    else
      level_locked level,i

  tween_star()
  game.time.events.add(Phaser.Timer.SECOND * 0.25, tween_gem, this)

update = ->

_states.levels =
  create: create
  update: update