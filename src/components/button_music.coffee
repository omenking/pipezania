class window.Component.ButtonMusic
  constructor:->
  create:=>
    @spirte = game.add.sprite  620, 512, 'audio_buttons'
    @spirte.frame = if _d.get_music() then 2 else 3
    @spirte.anchor.setTo 0.5, 0.5
    @spirte.inputEnabled = true
    @spirte.events.onInputDown.add @onclick, this
  onclick:=>
    if @sprite.frame is 2
      @sprite.frame = 3
      _d.set_music false
    else
      @sprite.frame = 2
      _d.set_music true
