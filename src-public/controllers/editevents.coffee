app.controller 'EditEventsCtrl', ($scope, moment) ->
  $scope.calendarView = 'month'
  $scope.calendarDay = new Date()
  $scope.events = [
    {
      title: 'Event 1'
      type: 'warning'
      startsAt: moment().startOf('week').subtract(2, 'days').add(8, 'hours').toDate()
      endsAt: moment().startOf('week').add(1, 'week').add(9, 'hours').toDate()
    }
  ]
