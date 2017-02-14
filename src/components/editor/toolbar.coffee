class Component.Editor.Toolbar
  constructor:->
    @btn_corner        = new Component.Editor.PipeButton @, 'corner'
    @btn_double_corner = new Component.Editor.PipeButton @, 'double_corner'
    @btn_straight      = new Component.Editor.PipeButton @, 'straight'
    @btn_cross         = new Component.Editor.PipeButton @, 'cross'

    @btn_start         = new Component.Editor.PipeButton @, 'start'
    @btn_end           = new Component.Editor.PipeButton @, 'end'
    @btn_null          = new Component.Editor.PipeButton @, 'null'
  reset:=>
    @alt    = false
    @active = false
    @toolbar = null
    @hotkeys = null
    @hotkey_clear = null
  str:=>
    @["btn_#{@active}"].str()
  inputs:=>
    @hotkeys = []
    @shift = game.input.keyboard.addKey(Phaser.Keyboard.SHIFT)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.A)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.S)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.D)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.F)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.G)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.H)
    @hotkeys.push game.input.keyboard.addKey(Phaser.Keyboard.V)
    for hotkey,i in @hotkeys
      hotkey.onDown.add @hotkey(i)

    @hotkey_alt = game.input.keyboard.addKey(Phaser.Keyboard.T)
    @hotkey_alt.onDown.add @toggle_alt

    @hotkey_clear = game.input.keyboard.addKey(Phaser.Keyboard.TILDE)
    @hotkey_clear.onDown.add @clear_active
  toggle_alt:=>
    @alt = !@alt
    @grid.set_alt @alt
    @g.clear()
    if @alt
      @g.beginFill 0xe30202
      @g.drawEllipse 0, 0, 8, 8
      @g.endFill()
  get_active:=>
    @active
  set_active:(kind)=>
    @active = kind
  clear_active:=>
    @active = false
    @hotkey(null)()
  hotkey:(n)=>
    =>
      btns = [
        @btn_corner
        @btn_double_corner
        @btn_straight
        @btn_cross
        @btn_start
        @btn_end
        @btn_null
      ]
      for btn,i in btns
        if n is i
          shift = @shift.isDown
          btn.active(shift)
        else
          btn.inactive()
  create:(grid)=>
    @grid = grid

    @reset()
    @inputs()

    @g = game.make.graphics (6*48) + (6*8), 0
    @g.reset()

    @toolbar = game.add.group()
    @toolbar.addChild @btn_corner.create        (0*48)
    @toolbar.addChild @btn_double_corner.create (1*48) + (1*8)
    @toolbar.addChild @btn_straight.create      (2*48) + (2*8)
    @toolbar.addChild @btn_cross.create         (3*48) + (3*8)
    @toolbar.addChild @btn_start.create         (4*48) + (4*8)
    @toolbar.addChild @btn_end.create           (5*48) + (5*8)
    @toolbar.addChild @btn_null.create          (6*48) + (6*8)
    @toolbar.addChild @g
    @toolbar.x = 160
    @toolbar.y = game.world.height - 56
