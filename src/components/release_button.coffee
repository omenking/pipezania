class Component.ReleaseButton
  constructor:(args)->
    @btn = null
  create:(onclick)=>
    x = 16 #game.world.width / 2
    y = (game.world.height - 32)
    @btn = game.add.sprite x, y, 'button_flow'
    @btn.inputEnabled = true
    @btn.events.onInputDown.add onclick, this
    @btn.frame = 0
    @btn.anchor.setTo 0, 0.5
  flow:=>
    @btn.frame = 1
