class Component.ButtonTab
  constructor:->
  create:(x,y,kind,callback)=>
    @kind     = kind
    @callback = callback
    @sprite = game.add.sprite 0, 0, 'tab'
    @sprite.inputEnabled = true
    @sprite.events.onInputDown.add @onclick, @
    @sprite.anchor.setTo 0.5, 0.5
    @sprite.angle += 180 if @kind is 'prev'
    @sprite.x = x
    @sprite.y = y
    @preview()
  onclick:=>
    if @kind is 'next'
      return if _d.page is 4
      _d.page += 1
    else
      return if _d.page is 0
      _d.page -= 1
    @callback()
  preview:=>
    @sprite.visible =
    if @kind is 'next'
      !(_d.page is 4)
    else
      !(_d.page is 0)
