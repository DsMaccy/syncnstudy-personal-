app.controller 'CalendarCtrl', ($scope, $auth, $modal, moment) ->
  $scope.name = ""
  $scope.token = $auth.getToken()
  $scope.email = ""
  $scope.calendarView = 'month'
  $scope.calendarDay = new Date()
  $scope.calendarViewTitle = ''

  ###
  Author: Kurt
  Capture ALL current user's class events
  Get current user
  Get current user's classes
  Get current user's classes' events
  Send to scope
  ###
  Classes = Parse.Object.extend('Classes')
  currUser = Parse.User.current() #get the current user

  enrolled = currUser.relation('enrolledClasses') #go get the current user's relation
  masterClassEventsArray = [] #declare the master array for all of the users courses

  userQuery = enrolled.query()
  userQuery.find
    success: (enrolledResult) ->
      l = 0
      while l < enrolledResult.length
        oneClass = enrolledResult[l]

        #now I have one class. Each class has an events relation
        classEvents = oneClass.relation('classevents')

        classEventsQuery = classEvents.query()
        classEventsQuery.find
          success: (ceResults) ->
            m = 0
            while m < ceResults.length
              oneClassEvent = ceResults[m]

              classEventsArray = []
              #indEventsArray['$SCOPE_VAR'] = oneIndEvent.get 'PARSE_VAR'
              classEventsArray['title'] = oneClassEvent.get 'title'
              classEventsArray['location'] = oneClassEvent.get 'location'
              classEventsArray['message'] = oneClassEvent.get 'message'
              classEventsArray['type'] = oneClassEvent.get 'type'
              classEventsArray['startsAt'] = oneClassEvent.get 'startsAt'
              classEventsArray['endsAt'] = oneClassEvent.get 'endsAt'

              masterClassEventsArray.push classEventsArray

              m++

      $scope.events = masterClassEventsArray
      $scope.$apply()


  ###
  Author: Kurt
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
        #indEventsArray['$SCOPE_VAR'] = oneIndEvent.get 'PARSE_VAR'
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


  ###
  Author: Kurt
  Save User's events into parse

  1. get current user
  2. get the event they wanted to save
  3. save user's event in parse
  ###
  $scope.saveEvent = (event) ->

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

  ###
  Author: Kurt
  Delete User's events from parse

  Get current user
  Query for event to delete
  Call obj.destroy()
  ###
  $scope.deleteEvent= (event) ->

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
