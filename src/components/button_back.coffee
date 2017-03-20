class window.Component.ButtonBack
  constructor:->
  create:=>
    @sprite = game.add.sprite 0, 0, 'back_button'
    @sprite.anchor.setTo 0.5, 0.5
    @sprite.y = 64
    @sprite.x = 96
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onclick, this
  onclick:=>
    game.state.start 'menu'
