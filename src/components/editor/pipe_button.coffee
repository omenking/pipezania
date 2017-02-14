class Component.Editor.PipeButton
  constructor:(toolbar,kind)->
    @toolbar = toolbar
    @kind    = kind
  create:(x)=>
    @group = game.make.group()
    @group.x = x

    @sprite = game.make.sprite 24, 24, 'pipes'
    @sprite.frame = @frame()
    @sprite.scale.setTo 0.75, 0.75
    @sprite.anchor.setTo 0.5, 0.5

    @g = game.make.graphics 0,0
    @render()
    @group.addChild @g
    @group.addChild @sprite
    @group
  render:(active=false)=>
    @g.reset()
    if active
      @g.lineStyle 2, 0xffd900
    else
      @g.lineStyle 2, 0x1c1c1c
    @g.beginFill 0x1c1c1c
    @g.drawRect  0 , 0, 48, 48
    @g.endFill()
  inactive:=>
    @render false
  frame:=>
    switch @kind
      when 'start'         then 4
      when 'end'           then 5
      when 'corner'        then 0
      when 'double_corner' then 1
      when 'straight'      then 2
      when 'cross'         then 3
      when 'null'          then null
  active:(shift)=>
    if @kind is @toolbar.active
      if shift
        @sprite.angle -= 90
      else
        @sprite.angle += 90
    @toolbar.set_active @kind
    @render true
  str:=>
    if @kind is 'null'
      null
    else
      ang =
      switch @angle()
        when 0   then 1
        when 90  then 2
        when 180 then 3
        when 270 then 4
      "#{@frame()}#{ang}#{ang}0"
  angle:=>
    # For some reason angles end up negative even though
    # we alawys add by 90. so we need to ensure its stays
    # positive
    angle = @sprite.angle
    angle = 360 + angle if angle < 0
    angle
