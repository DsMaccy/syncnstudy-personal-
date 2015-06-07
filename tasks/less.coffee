less = require('gulp-less');
concat = require 'gulp-concat'

gulp.task 'less', (done) ->
  gulp.src [
    'src-public/styles/*.less'
    'bower_components/ng-tags-input/*.min.css'
    'bower_components/angular-material/angular-material.min.css'
    'bower_components/md-date-time/dist/md-date-time.css'
  ]
  .pipe less()
  .pipe concat 'app.css'
  .pipe gulp.dest 'public/css'
  .on 'end', done
  return
