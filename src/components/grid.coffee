class Component.Grid
  constructor:(spill,counter,toolbar,success,fail)->
    @toolbar = toolbar
    @counter = counter
    @spill = spill
    @callback_success = success
    @callback_fail    = fail
    @reset()
  reset:=>
    @jewels =
      green: false
      blue : false
      red  : false
    @alt        = false
    @level      = null
    @speed      = null
    @flow_dir   = null
    @flowing    = false
    @grid       = null
    @pipes      = []
    @pipe_start = null
    @pipe_end   = null
    @_pipe      = null #current pipe returned by flowing
    @rotating =
      pipe: null
      angle: 0
  get_alt:=>
    @alt
  set_jewel:(i)=>
    if @pipes[i]
      @pipes[i].set_jewel()
  set_alt:(alt)=>
    @alt = alt
    for pipe in @pipes
      if pipe
        pipe.alt alt
  backup:=>
    data = []
    for pipe in @pipes
      v = if pipe then pipe.str() else 'null'
      data.push v
    data.join(',')
  is_toolbar_active:=>
    @toolbar.get_active()
  collect_jewel:(kind)=>
    @jewels[kind] = true
  start_flowing:=>
    return if @flowing
    @flowing  = true
    @_pipe    = @pipe_start
    @flow_dir = @_pipe.dir()
    @_pipe.tick = game.time.now
  update_rotating:=>
    if @rotating.pipe
      if @rotating.angle is 90
        @stop_rotating()
      else
        @rotate()
  rotating_pipe:=>
    @rotating.pipe
  set_rotating:(pipe)=>
    if _d.get_sound()
      switch @turnb
        when 1 then @turn1.play()
        when 2 then @turn2.play()
        when 3 then @turn3.play()
        when 4 then @turn4.play()
    @turnb++
    @turnb = 1 if @turnb is 5
    @rotating.pipe = pipe
  stop_rotating:=>
    @pipes[@rotating.pipe.i].set_angle()
    @rotating =
      pipe: null
      angle: 0
  rotate:=>
    @rotating.angle      += 10
    @rotating.pipe.angle += 10
  get:(i)=>
    switch @flow_dir
      when 'east'  then @pipes[i+1]
      when 'south' then @pipes[i+12]
      when 'west'  then @pipes[i-1]
      when 'north' then @pipes[i-12]
  next:=>
    pipe_last  = @_pipe
    pipe_next  = null
    @_pipe = null
    if pipe_last.kind is 'end'
      @callback_success(@jewels,@counter.time())
    else
      pipe_next = @get pipe_last.get_index()
      if pipe_next && pipe_next.dir()
        @_pipe      = pipe_next
        @_pipe.done = false
        @_pipe.tick = game.time.now
        @flow_dir   = pipe_next.dir()
      else
        @spill.spill @callback_fail, pipe_last, @flow_dir
  onclick_cell:(x,y)=>
    ny = if y > 0   then y / 64 else y
    nx = if x > 0   then x / 64 else x
    i  = if ny is 0 then nx     else (ny * 12) + nx
    old_child = @grid.children[i]
    new_child = game.make.sprite 0, 0, 'pipes'
    @grid.replace old_child, new_child
    child = @grid.children[i]
    child.x = x
    child.y = y
    @create_pipe @toolbar.str(), i
  set_tile:(tile)=>
    tile.inputEnabled = true
    fun = =>
      @onclick_cell tile.x, tile.y
    tile.events.onInputDown.add fun, this
  create_bg:=>
    # Nice background tiles.
    group = game.add.group()
    group.createMultiple 96, 'tile', 0, true
    group.align 12, 8, 64, 64
    if window.editor != false
      for tile in group.children
        @set_tile tile
  create_grid:=>
    @grid = game.add.group()
    @grid.createMultiple 96, 'pipes', 0, false
    @grid.align 12, 8, 64, 64
  create_pipes:=>
    @turnb = 1
    @turn1 = game.add.audio 'turn1'
    @turn2 = game.add.audio 'turn2'
    @turn3 = game.add.audio 'turn3'
    @turn4 = game.add.audio 'turn4'
    pipes  = if _l[@level] then _l[@level].pipes else new Array(96)
    for str,i in pipes
      @create_pipe str, i,
  create_pipe:(str,i)=>
    pipe = @grid.children[i]
    if str is null || str is undefined
      pipe.exists = false
      @pipes[i]   = null
    else
      pipe.i = i
      data   = str.split('')
      frame  = if data[0] then data[0]           else null
      ang1   = if data[1] then @angle(data[1])   else 0
      ang2   = if data[1] then @angle(data[2])   else 0
      jewel  = if data[3] then parseInt(data[3]) else 0
      @pipes[i] =
      switch @kind(frame)
        when 'start'
          @pipe_start = new Component.PipeStart @, pipe, ang1,ang2, i, 0
          @pipe_start
        when 'end'
          @pipe_end = new Component.PipeEnd @, pipe, ang1,ang2, i, 0
          @pipe_end
        when 'corner'        then new Component.PipeCorner       @, pipe, ang1,ang2, i, jewel
        when 'double_corner' then new Component.PipeDoubleCorner @, pipe, ang1,ang2, i, jewel
        when 'straight'      then new Component.PipeStraight     @, pipe, ang1,ang2, i, jewel
        when 'cross'         then new Component.PipeCross        @, pipe, ang1,ang2, i, jewel
  create:(level)=>
    @reset()
    @level = level
    switch _d.mode
      when 'adventure'
        @speed = 20
      when 'time'
        @speed = if _l[@level] then _l[@level].speed else 10
    @create_bg()
    @spill.create() # had to do it here it ensure correct layering.
    @create_grid()
    @create_pipes()
  update:=>
    @_pipe.update @next if @_pipe
    @update_rotating()
  kind:(frame)=>
    switch parseInt(frame)
      when 4 then 'start'
      when 5 then 'end'
      when 0 then 'corner'
      when 1 then 'double_corner'
      when 2 then 'straight'
      when 3 then 'cross'
  angle:(i)=>
    switch parseInt(i)
      when 1 then 0
      when 2 then 90
      when 3 then 180
      when 4 then 270
