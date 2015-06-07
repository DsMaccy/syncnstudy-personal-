app.controller 'StudyInvCtrl', ($scope, $auth, $alert, $window, ParseUtils) ->
  $scope.hours = [1..12]
  $scope.minutes = [1..59]
  $scope.classes = []
  $scope.inviteList = []
  $scope.userList = []

  $scope.loadUsers = (query) -> (user for user in $scope.userList when user.text.includes(query))

  $scope.sendInvite = (invite) ->
    Invite = Parse.Object.extend('Invite')
    newInvite = new Invite()
    newInvite.set('classTitle', invite.classTitle)
    newInvite.set('description', invite.description)
    newInvite.set('eventTitle', invite.eventTitle)
    newInvite.set('location', invite.location)

    # Date Shit: some stupid + 1 bs since default is UTC time...trying to manually convert...Pacific time ftw
    date = new Date(invite.date)
    #newHour = parseInt(invite.hour, 10) + (if (invite.ampm == 'p.m.') then 12 else 0)
    #newDay = parseInt(date.getDate(), 10) + 1
    #newDate = new Date(date.getFullYear(), date.getMonth(), newDay, newHour , invite.minute, 0,0)
    #newInvite.set('eventDate', newDate)
    date.setHours(invite.hour)
    date.setMinutes(invite.minute)
    newInvite.set('eventDate', date)

    # Prints correctly...parse doesn't get hours correctly
    #console.log('Year: ' + newDate.getFullYear()+ ', Month: ' + newDate.getMonth() + ', Day: '+ newDay +
      #', Hour: ' + newHour +  ', Minute: ' + invite.minute)
    console.log(date.toDateString() + ' Time: ' + date.toTimeString())

    newInvite.set('invitedList', invite.inviteList.map((invite) -> invite.text))
    Parse.User.current().fetch().then (user) ->
      newInvite.addUnique 'invitedList', user.get 'username'
      newInvite.set 'from', user.get 'username'
      newInvite.save()

  # Populate classes combo box
  ParseUtils.fetchObject 'Classes', (object) ->
    for aClass in object
      $scope.classes.push (aClass.get 'title')
    $scope.$apply()

  ParseUtils.fetchObject 'User', (object) ->
    for user in object
      username = (user.get 'username')
      $scope.userList.push {"text": username}
    $scope.$apply()
