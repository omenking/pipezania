class window.Component.CountGem
  constructor:->
  create:=>
    @group = game.add.group()
    i = _d.gem_count()
    txt = game.make.text 0,0, "#{i} / 300",
      font: '16px Verdana'
      fill: '#fff'
      align: 'center'
    txt.anchor.setTo 0.5, 0.5
    @sprite = game.add.sprite -75, -18, 'jewel_med'
    @group.addChild @sprite
    @group.addChild txt
    @group.x = 140
    @group.y = 512
    @animate()
  animate:=>
    game.time.events.add Phaser.Timer.SECOND * 0.25, @animate_delay, this
  animate_delay:=>
    tween = game.add.tween @sprite.scale
    tween.to {x: 1.07, y: 1.07},250, Phaser.Easing.Linear.None
    tween.to {x: 1, y: 1}      ,250, Phaser.Easing.Linear.None
    tween.loop true
    tween.start()
