class window.Component.ButtonSound
  constructor:->
  create:=>
    @sprite = game.add.sprite 680, 512, 'audio_buttons'
    @sprite.frame = if _d.get_sound() then 0 else 1
    @sprite.anchor.setTo 0.5, 0.5
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onclick, this
  onclick:=>
    if @sprite.frame is 0
      @sprite.frame = 1
      _d.set_sound false
    else
      @sprite.frame = 0
      _d.set_sound true
