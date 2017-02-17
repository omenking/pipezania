class controller
  constructor:(args)->
    @toolbar        = new Component.Editor.Toolbar()
    @spill          = new Component.Spill()
    @counter        = new Component.Counter()
    @grid           = new Component.Grid @spill, @counter, @toolbar, @success, @fail
    @clear_screen   = new Component.ClearScreen()
    @release_button = new Component.ReleaseButton()

  backup:=> #backup last edited level
    return if window.editor is false
    data = @grid.backup()
    ajax = new XMLHttpRequest()
    ajax.open 'POST', "http://localhost:1234/save/#{_d.level}/#{data}"
    ajax.setRequestHeader 'Content-Type', 'application/json'
    ajax.send()
  success:(jewels,time)=>
    @backup()
    if _d.get_sound()
      @sound_win.play()
    @clear_screen.show(true,jewels,time)
  fail_sound:=>
    #if _d.get_sound()
      #@sound_fail.play()
  fail:=>
    game.time.events.add(Phaser.Timer.SECOND * 0.2, @fail_sound, this)
    @backup()
    @clear_screen.show(false)
  release_goo:=>
    console.log 'release goo'
    @release_button.flow()

    if _d.get_sound()
      @sound_go.play()
    if _d.mode is 'time'
      @counter.stop()
    @grid.start_flowing()
  set_jewel:=>
    x = game.input.x
    y = game.input.y
    nx = Math.floor (x / 64)
    ny = Math.floor (y / 64)
    i  = if ny is 0 then nx else (ny * 12) + nx
    @grid.set_jewel(i)
  menubar_bg:=>
    g = game.add.graphics(0,0)
    g.beginFill 0x181919
    g.drawRect  0, game.world.height-64, 800, 64
    g.endFill()
  create:=>
    game.stage.disableVisibilityChange = true
    if window.editor != false
      save_hotkey = game.input.keyboard.addKey(Phaser.Keyboard.U)
      save_hotkey.onDown.add @backup

    jewel = game.input.keyboard.addKey(Phaser.Keyboard.ONE)
    jewel.onDown.add @set_jewel

    #@sound_spill = game.add.audio 'spill'
    @sound_go    = game.add.audio 'bubbles'
    @sound_win   = game.add.audio 'win'
    @sound_fail  = game.add.audio 'fail'

    space = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
    space.onDown.add @release_goo

    game.canvas.oncontextmenu = (e)-> e.preventDefault()
    game.stage.backgroundColor = 0x000000
    _d.cleared = false

    time = if window.editor != false then 10000 else _l[_d.level].countdown
    @menubar_bg()
    @release_button.create @release_goo
    @counter.create        @release_goo, time
    @grid.create _d.level
    if editor != false
      @toolbar.create @grid
    @clear_screen.create()

  update:=>
    @counter.update()
    @grid.update()
    @spill.update()
ctrl = new controller()

_states.play =
  create: ctrl.create
  update: ctrl.update
