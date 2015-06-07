gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

gulp.task 'vendor', (done) ->
  gulp.src [
    'bower_components/angular/angular.min.js'
    'bower_components/jquery/dist/jquery.js'
    'bower_components/angular-resource/angular-resource.min.js'
    'bower_components/angular-ui-router/release/angular-ui-router.min.js'
    'bower_components/angular-translate/angular-translate.min.js'
    'bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.min.js'
    'bower_components/angular-ui-bootstrap-bower/ui-bootstrap-tpls.min.js'
    'bower_components/angulartics/src/angulartics.js'
    'bower_components/angulartics/src/angulartics-ga.js'
    'bower_components/moment/moment.js'
    'bower_components/lodash/dist/lodash.js'
    'bower_components/angular-strap/dist/angular-strap.min.js'
    'bower_components/angular-strap/dist/angular-strap.tpl.min.js'
    'bower_components/satellizer/satellizer.min.js'
    'bower_components/angular-bootstrap-calendar/dist/js/angular-bootstrap-calendar-tpls.min.js'
    'bower_components/angular-stra/dist/js/angular-bootstrap-calendar-tpls.min.js'
    'bower_components/angular-animate/angular-animate.js'
    'bower_components/parse-js-sdk/lib/parse.min.js'
    'bower_components/ng-tags-input/ng-tags-input.min.js'
    'bower_components/bootstrap-material-design/dist/js/*.min.js'
    'bower_components/angular-animate/angular-animate.min.js'
    'bower_components/angular-aria/angular-aria.min.js'
    'bower_components/angular-material/angular-material.min.js'
    'bower_components/md-date-time/dist/md-date-time.js'
  ]
  .pipe(concat('vendor.js'))
  .on 'error', gutil.log
  .pipe gulp.dest('public/js')
  .on 'end', done
  return
