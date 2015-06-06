app.controller 'CalendarCtrl', ($scope, $auth, $modal, moment, Calendar) ->
  $scope.name = ""
  $scope.token = $auth.getToken()
  $scope.email = ""
  $scope.calendarView = 'month'
  $scope.calendarDay = new Date().toDateString()
  $scope.calendarViewTitle = ''
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
    $scope.email = Parse.User.current().getUsername()
    #$scope.name = Parse.User.current().get('name')
    #Parse.User.become($auth.getToken())
    #$scope.name = Parse.User.current().getName()

  init()

  showModal = undefined

  showModal = (action, event) ->
    $modal.open
      templateUrl: 'modalContent.html'
      controller: ($scope, $modalInstance) ->
        $scope.$modalInstance = $modalInstance
        $scope.action = action
        $scope.event = event
        return
    return


  $scope.eventClicked = (event) ->
    #showModal 'Clicked', event
    showModal = prompt(events)
    if person != null
      document.getElementById('Clicked').innerHTML = 'Hello ' + person + '! How are you today?'
    return

  $scope.eventEdited = (event) ->
    showModal 'Edited', event
    return

  $scope.eventDeleted = (event) ->
    showModal 'Deleted', event
    return

  $scope.toggle = ($event, field, event) ->
    $event.preventDefault()
    $event.stopPropagation()
    event[field] = !event[field]
    return
