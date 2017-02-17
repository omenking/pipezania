class Component.PipeEnd extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    @per1 += speed
    @done = true if @per1 is 100
  render:=>
    super
    @g.lineStyle 8, 0xffd900

    if @per1 >= 50
      v1 = 0
      v2 = (25 / 50) * (@per1 - 50)
    else if @per1 < 50
      v1 = (27 / 50) * @per1
      v2 = 0

    @g.moveTo 32    , 0
    @g.lineTo 32-v1 , 0

    @g.beginFill 0xffd900
    @g.lineStyle 0, 0x000000
    @g.drawRect  11-v2, -12, v2, 24
    @g.endFill()
    
    #markers for dumb people
    @g.beginFill 0xffd900
    @g.lineStyle 0, 0xffd900
    @g.drawEllipse -1, 0, 4, 4
    @g.endFill()
  set:=>
    @kind       = 'end'
    @pipe.frame = 5
    super
  dir:=>
    null
    switch @flow()
      when 'east'  then @angle() is 180
      when 'south' then @angle() is 270
      when 'west'  then @angle() is 0
      when 'north' then @angle() is 90
