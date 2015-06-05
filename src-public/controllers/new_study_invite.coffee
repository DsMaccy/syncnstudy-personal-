app.controller 'StudyInvCtrl', ($scope, $auth, $alert, $window, ParseUtilsService) ->
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

    date = new Date(invite.date)
    # some stupid + 1 bs since default is UTC time...trying to manually convert...Pacific time ftw
    newHour = parseInt(invite.hour, 10) + (if (invite.ampm == 'p.m.') then 12 else 0)
    newDay = parseInt(date.getDate(), 10) + 1
    console.log('Hour: ' + newHour)
    newDate = new Date(date.getFullYear(), date.getMonth(), newDay, newHour , invite.minute, 0,0)
    newInvite.set('eventDate', newDate)

    # Prints correctly...parse doesn't get hours correctly
    console.log('Year: ' + newDate.getFullYear()+ ', Month: ' + newDate.getMonth() + ', Day: '+ newDay +
      ', Hour: ' + newHour +  ', Minute: ' + invite.minute)

    newInvite.set()
    newInvite.save()

  # Populate classes combo box
  ParseUtilsService.fetchObject 'Classes', (object) ->
    for aClass in object
      $scope.classes.push (aClass.get 'title')
    $scope.$apply()

  ParseUtilsService.fetchObject 'User', (object) ->
    for user in object
      $scope.userList.push {"text": (user.get 'username')}
    $scope.$apply()
