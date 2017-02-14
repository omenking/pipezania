class Component.PipeCross extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    if (dir in ['east' ,'west']  && @angle() in [0,180]) ||
       (dir in ['south','north'] && @angle() in [90,270])
      @per1 += speed
      @done = true if @per1 is 100
    else if (dir in ['east' ,'west']  && @angle() in [90,270]) ||
            (dir in ['south','north'] && @angle() in [0,180])
      @per2 += speed
      @done = true if @per2 is 100
  render:=>
    super
    v1 = (64 / 100 ) * @per1

    v2 = 0
    v3 = 0
    if @per2 < 45
      v2 = (24 / 45 ) * @per2
    else if @per2 >= 55
      v2 = 24
      v3 = (24 / 45 ) * (@per2-55)
    else if @per2 >= 45
      v2 = 24
    # 0  45
    # 55 100
    #24

    @g.lineStyle 8, 0xffd900

    @rev1 =
    switch @flow()
      when 'west'  then @angle() is 0
      when 'north' then @angle() is 90
      when 'east'  then @angle() is 180
      when 'south' then @angle() is 270

    @rev2 =
    switch @flow()
      when 'north' then @angle() is 0
      when 'south' then @angle() is 180
      when 'west'  then @angle() is 270
      when 'east'  then @angle() is 90

    if @rev1
      @g.moveTo 32-v1, 0
      @g.lineTo 32   , 0
    else
      @g.moveTo -32  , 0
      @g.lineTo v1-32, 0

    if @rev2
      @g.moveTo 0, 32
      @g.lineTo 0, 32-v2

      @g.moveTo 0, -8
      @g.lineTo 0, -8-v3
    else
      @g.moveTo 0, -32
      @g.lineTo 0, v2-32
      @g.moveTo 0, 8
      @g.lineTo 0, 8+v3
  set:=>
    @kind       = 'cross'
    @pipe.frame = 3
    super
  dir:=>
    @flow()
