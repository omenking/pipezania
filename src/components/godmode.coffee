class controller
  constructor:->
    @$ =
      visible: false
      update: @update
  toggle:=>
    @$.visible = !@$.visible
    m.redraw(true)
  update:(i,kind)=>
    =>
      console.log 'update', i, kind
      jewels = {}
      jewels.red   = true if kind is 'r'
      jewels.green = true if kind is 'g'
      jewels.blue  = true if kind is 'b'
      _d.level_complete i, jewels, null

class view
  constructor:(ctrl)->
    @$ = ctrl
  level:(i)=>
    m 'tr',
      m 'td.id', i+1
      m 'td.checkbox',
        m 'span', 'r'
        m "input[type='checkbox']", onclick: @$.update(i,'r'),  checked: _d.level_status(i,'red')
      m 'td.checkbox',
        m 'span', 'g'
        m "input[type='checkbox']", onclick: @$.update(i,'g'), checked: _d.level_status(i,'green')
      m 'td.checkbox',
        m 'span', 'b'
        m "input[type='checkbox']", onclick: @$.update(i,'b'), checked: _d.level_status(i,'blue')
  render:=>
    return unless @$.visible
    m '.godmode',
      m '.wrap',
        m 'table',
          for i in [0..99]
            @level i


ctrl = new controller()
comp =
  controller: (args)-> ctrl.$
  view      : (c)->    new view(c).render()

class window.Component.GodMode
  constructor:->
    el = document.createElement "div"
    document.body.appendChild el
    m.mount el, comp

    document.addEventListener 'keydown', (ev)=>
      if ev.which is 187
        ctrl.toggle()
