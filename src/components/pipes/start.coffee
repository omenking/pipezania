class Component.PipeStart extends Component.Pipe
  tick_progress:=>
    speed = @grid.speed
    dir   = @flow()
    @per1 += speed
    @done = true if @per1 is 100
  render:=>
    super
    @g.lineStyle 8, 0xffd900

    if @per1 >= 50
      v1 = 8
      v2 = (32 / 50) * (@per1 - 50)
    else if @per1 < 50
      v1 = (8 / 50) * @per1
      v2 = 0

    @g.moveTo 0  , 0
    @g.lineTo v2 , 0

    @g.beginFill 0xffd900
    @g.drawEllipse -1, 0, v1, v1
    @g.endFill()

    #markers for dumb people
    @g.beginFill 0xffd900
    @g.lineStyle 0, 0xffd900
    @g.drawEllipse -1, 0, 4, 4
    @g.endFill()
  set:=>
    @kind       = 'start'
    @pipe.frame = 4
    super
  dir:=>
    switch @angle()
      when 0   then 'east'
      when 90  then 'south'
      when 180 then 'west'
      when 270 then 'north'

