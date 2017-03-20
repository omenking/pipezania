window._d   = new Data()
window.game = new  Phaser.Game 768, 576, Phaser.AUTO, 'phaser-example'
window.godmode = new Component.GodMode()
game.state.add 'boot'  , _states.boot
game.state.add 'load'  , _states.load
game.state.add 'menu'  , _states.menu
game.state.add 'levels', _states.levels
game.state.add 'play'  , _states.play

game.state.start 'boot'
