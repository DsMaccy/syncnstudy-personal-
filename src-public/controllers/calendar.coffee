app.controller 'CalendarCtrl', ($scope, $auth, $modal, moment) ->
  $scope.name = ""
  $scope.token = $auth.getToken()
  $scope.email = ""
  $scope.calendarView = 'month'
  $scope.calendarViewTitle = ''
  $scope.calendarDay = new Date()#.toDateString()
  $scope.$apply()
  #$scope.calendarViewTitle = ''

  ###
  Capture ALL current user's class events
  Get current user
  Get current user's classes
  Get current user's classes' events
  Send to scope
  ###
  Classes = Parse.Object.extend('Classes')
  currUser = Parse.User.current() #get the current user
  classEvents = currUser.relation('classEvents') #go get the current user's relation
  masterClassEventsArray = [] #declare the master array for all of the users courses

  classEventsQuery = classEvents.query()

  ###
  Capture ONLY current user's individual events
  Get current user
  Get current user's events
  Send to scope
  ###
  #Classes = Parse.Object.extend('Classes')
  #currUser = Parse.User.current() #get the current user
  indEvents = currUser.relation('individualEvents') #go get the current user's relation
  masterIndEventsArray = [] #declare the master array for all of the users courses

  indEventsQuery = indEvents.query()
  indEventsQuery.find
    success: (ieResults) ->
      k = 0
      while k < ieResults.length
        oneIndEvent = ieResults[k]

        indEventsArray = []
        # FORMAT indEventsArray['$SCOPE_VAR'] = oneIndEvent.get 'PARSE_VAR'
        indEventsArray['title'] = oneIndEvent.get 'title'
        indEventsArray['location'] = oneIndEvent.get 'location'
        indEventsArray['message'] = oneIndEvent.get 'message'
        indEventsArray['type'] = oneIndEvent.get 'type'
        indEventsArray['startsAt'] = oneIndEvent.get 'startsAt'
        indEventsArray['endsAt'] = oneIndEvent.get 'endsAt'

        masterIndEventsArray.push indEventsArray

        k++
      $scope.events = masterIndEventsArray
      $scope.$apply()
  console.log(masterIndEventsArray)

  classEvents = currUser.relation('classEvents')
  classEvents = classEvents.query()
  classEvents.find
    success: (classResults) ->
      k = 0
      while k < classResults.length
        oneIndEvent = classResults[k]

        indEventsArray = []
        # FORMAT indEventsArray['$SCOPE_VAR'] = oneIndEvent.get 'PARSE_VAR'
        indEventsArray['title'] = oneIndEvent.get 'title'
        indEventsArray['location'] = oneIndEvent.get 'location'
        indEventsArray['message'] = oneIndEvent.get 'message'
        indEventsArray['type'] = oneIndEvent.get 'type'
        indEventsArray['startsAt'] = oneIndEvent.get 'startsAt'
        indEventsArray['endsAt'] = oneIndEvent.get 'endsAt'

        masterIndEventsArray.push indEventsArray

        k++
      $scope.events = masterIndEventsArray
      $scope.$apply()





  init = ->
    $scope.email = Parse.User.current().getUsername()


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


  $scope.saveEvent = (event) ->
    ###
    Save User's events into parse

    1. get current user
    2. get the event they wanted to save
    3. save user's event in parse
    ###
    console.log('you just tried to save an event!')

    Event = Parse.Object.extend('Event')
    parseEvent = new Event

    parseEvent.set 'title', event.title
    parseEvent.set 'location', event.location
    parseEvent.set 'message', event.message
    parseEvent.set 'type', event.type
    parseEvent.set 'startsAt', event.startsAt
    parseEvent.set 'endsAt', event.endsAt

    parseEvent.save
      success: ->
        indEvents = Parse.User.current().relation('individualEvents') #go get the current user's relation
        indEvents.add parseEvent
        Parse.User.current().save()
        location.reload()
        return


        #Parse.User.current().save()


  $scope.deleteEvent= (event) ->
    ###
    Delete User's events from parse
    ###
    console.log('you just tried to delete an event!')
    console.log(event)

    ###
    get current user
    query for event to delete
    call obj.destroy()
    ###
    currUser = Parse.User.current() #get the current user
    delEvent = currUser.relation('individualEvents') #go get the current user's relation

    userQuery = delEvent.query()
    userQuery.equalTo 'title', event.title
    userQuery.first
      success: (searchResult) ->
        searchResult.destroy()

        currUser.save()
        location.reload()
        return
