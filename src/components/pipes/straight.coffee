class Component.PipeStraight extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    if (dir in ['east' ,'west']  && @angle() in [0,180]) ||
       (dir in ['south','north'] && @angle() in [90,270])
      @per1 += speed
      @done = true if @per1 is 100
  render:=>
    super
    v = (64 / 100 ) * @per1
    @g.lineStyle 8, 0xffd900

    @rev1 =
    switch @flow()
      when 'east'  then @angle() is 180
      when 'south' then @angle() is 270
      when 'west'  then @angle() is 0
      when 'north' then @angle() is 90

    if @rev1
      @g.moveTo 32-v, 0
      @g.lineTo 32  , 0
    else
      @g.moveTo -32  , 0
      @g.lineTo v-32 , 0
  set:=>
    @kind       = 'straight'
    @pipe.frame = 2
    super
  dir:=>
    switch @flow()
      when 'east'
        switch @angle()
          when 0,180 then 'east'
          else
            false

      when 'south'
        switch @angle()
          when 90, 270 then 'south'
          else
            false
      when 'west'
        switch @angle()
          when 0, 180 then 'west'
          else
            false
      when 'north'
        switch @angle()
          when 90, 270  then 'north'
          else
            false
