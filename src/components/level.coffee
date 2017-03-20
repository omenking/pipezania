class window.Component.Level
  constructor:->
  create:(sprite,i)->
    @sprite = sprite
    @create_label()
    @create_count()
    @create_jewels()
    @set i
  create_count:=>
    @count = game.make.text 50, 72, '',
      font: '12px Verdana'
      fill: '#000'
      align: 'center'
    @count.anchor.setTo 0.5, 0.5
    @sprite.addChild @count
  create_label:=>
    @label = game.make.text 0,0, ''
    @label.anchor.setTo 0.5, 0.5
    @sprite.addChild @label
  create_jewels:=>
    inline = 30
    @red   = game.make.sprite inline        , 68, 'jewels'
    @green = game.make.sprite (128/2)-3     , 68, 'jewels'
    @blue  = game.make.sprite 128-(inline+4), 68, 'jewels'

    scale = 0.7
    @red.scale.setTo   scale, scale
    @green.scale.setTo scale, scale
    @blue.scale.setTo  scale, scale

    anchor = 0.5
    @red.anchor.setTo   anchor, anchor
    @green.anchor.setTo anchor, anchor
    @blue.anchor.setTo  anchor, anchor

    @sprite.addChild @red
    @sprite.addChild @blue
    @sprite.addChild @green
  set:(i)=>
    @sprite.i = i
    if _d.is_unlocked(i)
      switch _d.mode
        when 'time'      then @unlocked_time      i
        when 'adventure' then @unlocked_adventure i
    else
      @locked i
  locked:(i)=>
    @label.visible = false
    @red.visible   = false
    @green.visible = false
    @blue.visible  = false

    ids           = [95,96,97,98,99]
    @sprite.frame = if i in ids then 3 else 1
    count         = _d.needed_to_unlock i
    @count.setText count
    @count.visible = true
  unlocked_time:(i)=>
    @sprite.frame  = 4
    @red.visible   = false
    @count.visible = false
    @green.visible = false
    @blue.visible  = false


    @label.setText "#{i+1}"
    @label.visible = true
    @label.x = @sprite.width / 2
    @label.y = (@sprite.height / 2) - 8
    @label.font     = 'Verdana'
    @label.fontSize = 18
    @label.fill     = '#000'
    @label.align    = 'center'

    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onclick, this

    t = _d.tlevel(i)
    if t != null && t != undefined
      @sprite.frame = 5

  unlocked_adventure:(i)=>
    @sprite.frame  = 0
    @count.visible = false
    @red.visible   = true
    @green.visible = true
    @blue.visible  = true

    @red.frame   = @jewel_color i, 'red'
    @green.frame = @jewel_color i, 'green'
    @blue.frame  = @jewel_color i, 'blue'

    @label.setText "#{i+1}"
    @label.visible = true
    @label.x = @sprite.width / 2
    @label.y = (@sprite.height / 2) - 14
    @label.font     = 'Verdana'
    @label.fontSize = 18
    @label.fill     = '#fff'
    @label.align    = 'center'

    if _d.level_status(i,'red')   &&
       _d.level_status(i,'green') &&
       _d.level_status(i,'blue')
      @sprite.frame = 2
      @label.fill = '#000'

    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onclick, this

  jewel_color:(i,kind)=>
    if _d.level_status(i,kind)
      switch kind
        when 'red'   then 1
        when 'green' then 2
        when 'blue'  then 3
    else
      0
  onclick:=>
    _d.level = @sprite.i
    game.state.start 'play'
