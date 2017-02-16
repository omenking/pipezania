_states.boot =
  create: ->
    window.game.stage.disableVisibilityChange = true
    window.game.state.start 'load'
