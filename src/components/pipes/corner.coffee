class Component.PipeCorner extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    @per1 += speed
    @done = true if @per1 is 100
  render:=>
    super
    v = (90 / 100) * @per1
    @g.lineStyle 8, 0xffd900

    @rev1 =
    switch @flow()
      when 'east'  then @angle() is 180
      when 'south' then @angle() is 270
      when 'west'  then @angle() is 0
      when 'north' then @angle() is 90

    if @rev1
      @g.arc -32, -32, 32, game.math.degToRad(0), game.math.degToRad(v), false
    else
      @g.arc -32, -32, 32, game.math.degToRad(90-v), game.math.degToRad(90), false
  set:=>
    @kind       = 'corner'
    @pipe.frame = 0
    super
  dir:=>
    switch @flow()
      when 'east'
        switch @angle()
          when 0   then 'north'
          when 270 then 'south'
          else
            false
      when 'south'
        switch @angle()
          when 0  then 'west'
          when 90 then 'east'
          else
            false
      when 'west'
        switch @angle()
          when 90  then 'north'
          when 180 then 'south'
          else
            false
      when 'north'
        switch @angle()
          when 270 then 'west'
          when 180 then 'east'
          else
            false
