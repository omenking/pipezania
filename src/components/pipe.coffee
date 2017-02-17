class Component.Pipe
  constructor:(grid,pipe,ang1,ang2,index,jewel)->
    @index    = index
    @grid     = grid
    @pipe     = pipe
    @angle_set  = ang1
    @angle_rnd  = ang2
    @tick     = null
    @g = game.make.graphics 0, 0
    @pipe.addChild @g # stores the flowing graphic

    px = @grid.gridpx() / 2
    @jewel = null
    @jewel = new Component.Jewel jewel, @pipe.x+px, @pipe.y+px if jewel != 0
    @pipe.inputEnabled = true
    @pipe.events.onInputDown.add @onclick, this

    @pipe.scale.setTo @grid.gridscale(), @grid.gridscale()
    @pipe.anchor.setTo 0.5, 0.5
    @pipe.x += px
    @pipe.y += px
    @pipe.exists = true
    @per1 = 0 # progress 1
    @per2 = 0 # progress 2
    @rev1 = false # reverse flow of progress 1
    @rev2 = false # reverse flow of progress 2
    @done = false
    @g.clear()
    @set()

    @render()
  set_jewel:=>
    if @jewel is null
      @jewel = new Component.Jewel 1, @pipe.x, @pipe.y
    else
      @jewel.jewel.destroy()
      if @jewel.get_i() is 3
        @jewel = null
      else
        i = @jewel.get_i()
        i += 1
        @jewel = new Component.Jewel i, @pipe.x, @pipe.y
  get_index:=>
    @index
  flow:=>
    @grid.flow_dir
  update:(ondone)=>
    if (game.time.now - @tick > 10)
      @tick =  game.time.now
      if @done
        ondone()
      else
        @tick_progress()
        @render()
  render:=>
    kind  = @pipe.kind
    g     = @pipe.children[0]
    angle = @angle()
    rev1  = false
    rev2  = false
    if @jewel && (@per1 > 50 || @per2 > 50)
      @jewel.collect(@grid)
  alt:(alt)=>
    ang = if @grid.get_alt() then @angle_rnd else @angle_set
    @pipe.angle = ang
  angle:=>
    # For some reason angles end up negative even though
    # we alawys add by 90. so we need to ensure its stays
    # positive
    angle = @pipe.angle
    angle = 360 + angle if angle < 0
    angle
  str:=>
    ang1 =
    switch @angle_rnd
      when 0   then 1
      when 90  then 2
      when 180 then 3
      when 270 then 4
    ang2 =
    switch @angle_set
      when 0   then 1
      when 90  then 2
      when 180 then 3
      when 270 then 4
    jewel = if @jewel then @jewel.get_i() else 0
    "#{@pipe.frame}#{ang1}#{ang2}#{jewel}"
  set_angle:=>
    if @grid.get_alt()
      @angle_rnd = @angle()
    else
      @angle_set = @angle()
  set:=>
    ang = if @grid.get_alt() then @angle_rnd else @angle_set
    @pipe.angle = ang
  onclick:(pipe)=>
    if editor != false && @grid.is_toolbar_active()
      px = @grid.gridpx() / 2
      @grid.onclick_cell pipe.x-px, pipe.y-px
    else
      unless @grid.rotating_pipe() ||
             @kind in ['start','end'] ||
             @per1  > 0 ||
             @per2 > 0
        @grid.set_rotating pipe
