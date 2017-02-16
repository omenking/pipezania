class Component.Counter
  constructor:(args)->
  style:=>
    font: '28px Verdana'
    fill: '#fff'
    align: 'center'
  reset:=>
    @text     = null
    @timer    = null
    @timer_ev = null
    @secs     = 0
  stop:=>
    @secs = @t_secs()
    @timer.stop()
  format_time:(s)=>
    mins = "0" + Math.floor(s / 60)
    secs = "0" + (s - mins * 60)
    mins.substr(-2) + ":" + secs.substr(-2)
  create:(onend,seconds=10)=>
    @reset()
    x = game.world.width - 60
    y = (game.world.height - 32)
    @text = game.add.text x , y, '', @style()
    @text.anchor.setTo 0.5, 0.5
    switch _d.mode
      when 'time'
        @timer    = game.time.create()
        @timer_ev = @timer.add(Phaser.Timer.SECOND * seconds, onend, this)
        @timer.start()
      when 'adventure'
        time = @format_time 0
        @text.setText time
        game.time.events.loop(Phaser.Timer.SECOND, @update_counter, this)
  time:=>
    @secs
  t_secs:=>
    Math.round (@timer_ev.delay - @timer.ms) / 1000
  update_counter:=>
    @secs++
    time = @format_time @secs
    @text.setText time
  update:=>
    switch _d.mode
      when 'time'
        return unless @timer.running
        s = @t_secs()
        @text.fill = '#d60225' if s <= 5
        time = @format_time s
        @text.setText time
