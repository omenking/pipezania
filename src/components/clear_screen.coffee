class Component.ClearScreen
  constructor:(win,fail)->
    @success = null
    @bg = null
    @btn_level = null
    @btn_again = null
    @btn_next  = null
  show:(success,jewels,time)=>
    @jewel_red.frame   = if jewels && jewels.red   then 1 else 3
    @jewel_green.frame = if jewels && jewels.green then 0 else 3
    @jewel_blue.frame  = if jewels && jewels.blue  then 2 else 3
    if success
      _d.level_complete _d.level, jewels, time
      game.time.events.add(Phaser.Timer.SECOND * 0.5, @now_show, this)
    else
      game.time.events.add(Phaser.Timer.SECOND * 1, @now_show, this)
    if _d.is_unlocked(_d.level+1)
      @btn_next.exists = true
    else
      @btn_next.exists = false
  now_show:=>
    @bg.alpha = 0
    @btn_levels.scale.setTo 0,0
    @btn_again.scale.setTo  0,0
    @btn_next.scale.setTo   0,0
    @bg.exists = true

    tween = game.add.tween @bg
    tween.to {alpha: 1} ,200, Phaser.Easing.Linear.None
    tween.start()
    tween.onComplete.add @bounce_actions, this
  bounce_actions:=>
    @bounce_btn @btn_levels, 0
    @bounce_btn @btn_again , 0.25
    @bounce_btn @btn_next  , 0.5
  bounce_btn:(btn,secs)=>
    bounce = =>
      tween = game.add.tween btn.scale
      tween.to {x: 1, y: 1},600, Phaser.Easing.Elastic.Out
      tween.start()
    game.time.events.add(Phaser.Timer.SECOND * secs, bounce, this)
  onclick_levels:=>
    game.state.start 'levels'
  onclick_again:=>
    game.state.start 'play'
  onclick_next:=>
    _d.level += 1
    game.state.start 'play'
  create:=>
    @bg = game.add.sprite 0,0, 'clear_screen'

    @jewel_red = game.make.sprite 0, 0, 'jewels_large'
    @jewel_red.anchor.setTo 0.5, 0.5
    @jewel_red.x = 240
    @jewel_red.y = (4*64)+24

    @jewel_green = game.make.sprite 0, 0, 'jewels_large'
    @jewel_green.anchor.setTo 0.5, 0.5
    @jewel_green.x = game.world.width / 2
    @jewel_green.y = (4*64)+24

    @jewel_blue = game.make.sprite 0, 0, 'jewels_large'
    @jewel_blue.anchor.setTo 0.5, 0.5
    @jewel_blue.x = game.world.width - 240
    @jewel_blue.y = (4*64)+24

    @btn_levels = game.make.button 384-96, 384, 'clear_buttons', @onclick_levels, this, 0, 0, 0
    @btn_again  = game.make.button 384   , 384, 'clear_buttons', @onclick_again , this, 3, 3, 3
    @btn_next   = game.make.button 384+96, 384, 'clear_buttons', @onclick_next  , this, 6, 6, 6

    @btn_levels.anchor.setTo 0.5, 0.5
    @btn_again.anchor.setTo  0.5, 0.5
    @btn_next.anchor.setTo   0.5, 0.5

    @bg.addChild @btn_again
    @bg.addChild @btn_next
    @bg.addChild @btn_levels

    @bg.addChild @jewel_red
    @bg.addChild @jewel_green
    @bg.addChild @jewel_blue
    @bg.exists = false
  update:=>
