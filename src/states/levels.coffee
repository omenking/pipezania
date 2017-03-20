class controller
  constructor:(args)->
    @count_gem    = new Component.CountGem()
    @count_star   = new Component.CountStar()

    @button_sound = new Component.ButtonSound()
    @button_music = new Component.ButtonMusic()
    @button_back  = new Component.ButtonBack()

    @tab_prev     = new Component.ButtonTab()
    @tab_next     = new Component.ButtonTab()
  update_tabs:=>
    @tab_prev.preview()
    @tab_next.preview()
    @update_levels()
    for bg in @bgs
      bg.visible = false
    @bg_active = @bgs[_d.page]
    @bg_active.visible = true
  update_levels:=>
    offset = _d.page * 20
    for level,i in @levels
      level.set offset+i
  create_title:=>
    @title = game.add.sprite  0, 0, "label_#{_d.mode}"
    @title.anchor.setTo 0.5, 0.5
    @title.y = 64
    @title.x = game.world.centerX
  create_levels:=>
    @group = game.add.group()
    @group.createMultiple 20, 'levels', 0, true
    @group.align 5, 4, 128, 96
    @group.x = (game.world.width  / 2) - (@group.width  / 2)
    @group.y = (game.world.height / 2) - (@group.height / 2)
    @levels = []
    for level,i in @group.children
      @levels.push @create_level(level,i)
  create_level:(level,i)=>
    lvl = new Component.Level()
    lvl.create level, i
    lvl
  create:=>
    _d.page = 0
    game.stage.backgroundColor = '#1c1c1c'
    @bgs = []
    @bgs.push game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg1'
    @bgs.push game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg2'
    @bgs.push game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg3'
    @bgs.push game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg4'
    @bgs.push game.add.tileSprite 0, 0, game.world.width, game.world.height, 'bg5'

    @create_title()
    @button_back.create()

    @button_sound.create()
    @button_music.create()

    @create_levels()

    cx = game.world.width
    cy = game.world.centerY
    fun = =>
      @tab_prev.preview()
      @tab_next.preview()
    @tab_prev.create 24   , cy, 'prev', @update_tabs
    @tab_next.create cx-24, cy, 'next', @update_tabs
    @update_tabs()

    @count_star.create()
    @count_gem.create()
ctrl = new controller()

_states.levels =
  create: ctrl.create
