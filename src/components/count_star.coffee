class window.Component.CountStar
  constructor:->
  create:=>
    @group = game.add.group()
    i = _d.star_count()
    txt = game.make.text 0,0, "#{i} / 100",
      font: '16px Verdana'
      fill: '#fff'
      align: 'center'
    txt.anchor.setTo 0.5, 0.5
    @sprite = game.add.sprite -75, -20, 'star_med'
    @group.addChild @sprite
    @group.addChild txt
    @group.x = 270
    @group.y = 512
    @animate()
  animate:=>
    tween = game.add.tween @sprite.scale
    tween.to {x: 1.07, y: 1.07},250, Phaser.Easing.Linear.None
    tween.to {x: 1, y: 1}    ,250, Phaser.Easing.Linear.None
    tween.loop true
    tween.start()
