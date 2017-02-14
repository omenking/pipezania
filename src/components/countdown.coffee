class Component.Countdown
  constructor:(args)->
    @text     = null
    @timer    = null
    @timer_ev = null
  style:=>
    font: '28px Verdana'
    fill: '#fff'
    align: 'center'
  stop:=>
    @timer.stop()
  format_time:(s)=>
    mins = "0" + Math.floor(s / 60)
    secs = "0" + (s - mins * 60)
    mins.substr(-2) + ":" + secs.substr(-2)
  create:(onend,seconds=10)=>
    x = game.world.width - 60
    y = (game.world.height - 32)
    @text = game.add.text x , y, '', @style()
    @text.anchor.setTo 0.5, 0.5

    @timer    = game.time.create()
    @timer_ev = @timer.add(Phaser.Timer.SECOND * seconds, onend, this)
    @timer.start()
  update:=>
    return unless @timer.running
    s    = Math.round (@timer_ev.delay - @timer.ms) / 1000
    if s <= 5
      @text.fill = '#d60225'
    time = @format_time s
    @text.setText time
