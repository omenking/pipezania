class Component.Spill
  constructor:->
  reset:=>
    @g.clear()
    @per = 0
    @spilling = false
    @tick     = null
  create:=>
    @group = game.add.group()
    @g     = game.make.graphics 0, 0
    @group.addChild @g
    @reset()
  spill:(fail,pipe,flow_dir)=>
    switch flow_dir
      when 'east'
        @group.x = pipe.pipe.x + 32
        @group.y = pipe.pipe.y
      when 'south'
        @group.x = pipe.pipe.x
        @group.y = pipe.pipe.y + 32
      when 'north'
        @group.x = pipe.pipe.x
        @group.y = pipe.pipe.y - 32
      when 'west'
        @group.x = pipe.pipe.x - 32
        @group.y = pipe.pipe.y
    return if @spilling
    @spilling = true
    @tick     = game.time.now
    fail()
  render:=>
    @g.reset()
    @g.beginFill 0xffd900
    @g.drawEllipse -1, 0, @per, @per
    @g.endFill()
  update:=>
    if @spilling && @per < 320 && (game.time.now - @tick > 10)
      @tick =  game.time.now
      if      @per < 50  then @per += 1
      else if @per < 100 then @per += 0.5
      else if @per < 200 then @per += 0.25
      else if @per < 250 then @per += 0.10
      else if @per < 320 then @per += 0.05
      @render()
