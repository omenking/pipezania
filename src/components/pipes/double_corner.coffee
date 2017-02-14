class Component.PipeDoubleCorner extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    if @angle() is 0   && dir in ['west','north'] ||
       @angle() is 90  && dir in ['north','east'] ||
       @angle() is 180 && dir in ['east','south'] ||
       @angle() is 270 && dir in ['south','west']
      @per1 += speed
      @done = true if @per1 is 100
    if @angle() is 0   && dir in ['east','south'] ||
       @angle() is 90  && dir in ['south','west'] ||
       @angle() is 180 && dir in ['west','north'] ||
       @angle() is 270 && dir in ['north','east']
      @per2 += speed
      @done = true if @per2 is 100
  render:=>
    super
    v1 = (90 / 100) * @per1
    v2 = (90 / 100) * @per2
    @g.lineStyle 8, 0xffd900

    @rev1 =
    switch @flow()
      when 'east'   then @angle() is 180
      when 'south'  then @angle() is 270
      when 'west'   then @angle() is 0
      when 'north'  then @angle() is 90

    @rev2 =
    switch @flow()
      when 'east'   then @angle() is 0
      when 'south'  then @angle() is 90
      when 'west'   then @angle() is 180
      when 'north'  then @angle() is 270

    if @rev1
      @g.arc -32, -32, 32, game.math.degToRad(0), game.math.degToRad(v1), false
    else
      @g.arc -32, -32, 32, game.math.degToRad(90-v1), game.math.degToRad(90), false

    if @rev2
      @g.arc 32 , 32 , 32, game.math.degToRad(180), game.math.degToRad(180+v2), false
    else
      @g.arc 32 , 32 , 32, game.math.degToRad(270-v2), game.math.degToRad(270), false
  set:=>
    @kind       = 'double_corner'
    @pipe.frame = 1
    super
  dir:=>
    switch @flow()
      when 'east'
        switch @angle()
          when 0,180  then 'north'
          when 90,270 then 'south'
      when 'south'
        switch @angle()
          when 0,180  then 'west'
          when 90,270 then 'east'
      when 'west'
        switch @angle()
          when 0,180  then 'south'
          when 90,270 then 'north'
      when 'north'
        switch @angle()
          when 90,270 then 'west'
          when 0,180 then 'east'

