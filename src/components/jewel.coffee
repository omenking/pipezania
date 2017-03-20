class Component.Jewel
  constructor:(i,x,y)->
    @collected = false
    @i = i
    @kind =
    switch i
      when 1 then 'red'
      when 2 then 'green'
      when 3 then 'blue'
    @sparkle = game.add.audio 'sparkle'
    @jewel = game.add.sprite x, y, 'jewels'
    @jewel.frame = i
    @jewel.anchor.setTo 0.5, 0.5
    @jewel
  get_i:=>
    @i
  animate:=>
    tween = game.add.tween(@jewel.scale)
    tween2 = game.add.tween(@jewel)
    tween.to {x: 2, y: 2},300, Phaser.Easing.Linear.None
    tween2.to {alpha: 0} ,300
    tween.start()
    tween2.start()
  collect:(grid)=>
    return if @collected
    @collected = true
    if _d.get_sound()
      @sparkle.play()
    @animate()
    grid.collect_jewel @kind
