class window.Data
  ver: '1.0.0'
  changelog:=>
    []
  constructor:->
    @data = {
      levels : []
      tlevels: [] #timed_levels
    }
  tlevel:(i)=>
    return null unless @data.tlevels
    @data.tlevels[i]
  level_status:(i,v)=>
    if @data.levels
      lvl = @data.levels[i]
      switch v
        when 'complete' then lvl && lvl.indexOf('t') != -1
        when 'red'      then lvl && lvl.indexOf('r') != -1
        when 'green'    then lvl && lvl.indexOf('g') != -1
        when 'blue'     then lvl && lvl.indexOf('b') != -1
    else
      false
  get_sound:=>
    if @data.sound is undefined
      true
    else
      @data.sound
  set_sound:(v)=>
    @data.sound = v
    @save()
  get_music:=>
    if @data.music is undefined
      true
    else
      @data.music
  set_music:(v)=>
    @data.music = v
    @save()
  needed_to_unlock:(level)=>
    if level >= 17
      switch level
        when 17 then 12
        when 18 then 16
        when 19 then 19
    else
      (level*3)-2
  gem_count:=>
    count = 0
    if @data.levels
      for lvl in @data.levels
        if lvl
          count++ if lvl.indexOf('r') != -1
          count++ if lvl.indexOf('g') != -1
          count++ if lvl.indexOf('b') != -1
    count
  star_count:=>
    count = 0
    if @data.levels
      for lvl in @data.levels
        if lvl &&  lvl.indexOf('r') != -1 &&
                   lvl.indexOf('g') != -1 &&
                   lvl.indexOf('b') != -1
          count++
    count
  is_unlocked:(level)=>
    switch level
      when 17 then @star_count() >= 12
      when 18 then @star_count() >= 16
      when 19 then @star_count() >= 19
      when 0  then true
      else
        @gem_count() >= (level*3)-2
  level_complete:(i,jewels,time)=>
    switch @mode
      when 'time'
        if jewels.red && jewels.green && jewels.blue
          @data.tlevels    = [] unless @data.tlevels
          @data.tlevels[i] = time
          @save()
      when 'adventure'
        str = ['t']
        str.push 'r' if jewels.red    || @level_status i, 'red'
        str.push 'g' if jewels.green  || @level_status i, 'green'
        str.push 'b' if jewels.blue   || @level_status i, 'blue'
        str = str.join ''
        @data.levels    = [] unless @data.levels
        @data.levels[i] = str
        @save()
  reset:=>
    store.remove 'save'
  load:=>
    if save = store.get 'save'
      @data = JSON.parse LZString.decompressFromBase64(save)
  save:=>
    save = JSON.stringify(@data)
    save = LZString.compressToBase64 save
    store.set 'save', save
    save
