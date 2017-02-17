var gulp   = require('gulp')
//var reload = require('gulp-livereload')
var coffee = require('gulp-coffee')
var concat = require('gulp-concat')
var addsrc = require('gulp-add-src')
var uglify = require('gulp-uglify')

var js_init  = './src/init.js'

var js_lib  = [
    "./src/lib/lz.js"
  , "./src/lib/store.js"
  , "./src/lib/phaser.js"
]

var js_lvls = "./src/levels/*.js"

var js_app = [
  , './src/components/clear_screen.coffee'
  , './src/components/counter.coffee'
  , './src/components/grid.coffee'
  , './src/components/jewel.coffee'
  , './src/components/pipe.coffee'
  , './src/components/release_button.coffee'
  , './src/components/spill.coffee'

  , './src/components/editor/pipe_button.coffee'
  , './src/components/editor/toolbar.coffee'

  , './src/components/pipes/corner.coffee'
  , './src/components/pipes/cross.coffee'
  , './src/components/pipes/double_corner.coffee'
  , './src/components/pipes/end.coffee'
  , './src/components/pipes/start.coffee'
  , './src/components/pipes/straight.coffee'

  , './src/states/boot.coffee'
  , './src/states/levels.coffee'
  , './src/states/load.coffee'
  , './src/states/menu.coffee'
  , './src/states/play.coffee'

  , './src/data.coffee'
  , './src/game.coffee'
]

gulp.task('js', function() {
  return gulp.src(js_app)
    .pipe(coffee())
    .pipe(addsrc.append(js_lvls))
    .pipe(addsrc.prepend(js_lib))
    .pipe(addsrc.prepend(js_init))
    .pipe(concat('app.js'))
    //.pipe(uglify())
    .pipe(gulp.dest('./public/'));
});

gulp.task('default', function () {
  gulp.run('js');
});

gulp.task('watch', function () {
  //reload.listen()
  gulp.watch(
    [
      './src/init.js',
      './src/**/*.coffee',
    ]
  , ['js']);
});
