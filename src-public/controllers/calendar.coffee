app.controller 'CalendarCtrl', ($scope, $auth, moment, ParseSDK) ->
  $scope.email = ""
  $scope.calendarView = 'month'
  $scope.calendarDay = new Date()
  $scope.calendarViewTitle = 'view-T'
  $scope.events = [
    {
      title: 'Event 1'
      location: 'Your mom\'s place'
      message: 'Massage'
      type: 'warning'
      startsAt: moment().startOf('week').subtract(2, 'days').add(8, 'hours').toDate()
      endsAt: moment().startOf('week').add(1, 'week').add(9, 'hours').toDate()
    }
    {
      title: 'Event 2'
      location: 'Your mom\'s place'
      message: 'Massage'
      type: 'info'
      startsAt: moment().subtract(1, 'day').toDate()
      endsAt: moment().add(5, 'days').toDate()
      editable: true
      deletable: true
    }
    {
      title: 'This is a really long event title'
      location: 'Your mom\'s place'
      message: 'Massage'
      type: 'important'
      startsAt: moment().startOf('day').add(5, 'hours').toDate()
      endsAt: moment().startOf('day').add(19, 'hours').toDate()
    }
  ]
  init = ->
    ParseSDK.initialize('H3mf7FlzKF0fZdNIvGntzqI1TWn0y3gWXjB2FIth','muAXvNfPtfay3imFx07NG0YT2ac2Z33qdrsy9fLV')
    ParseSDK.User.become($auth.getToken(),{useMasterKey: false}).then ((user) ->
        $scope.email = user.email
        return
      )
  init()
