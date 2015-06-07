app.controller 'InvitesCtrl', ($scope) ->
  $scope.invites = []
  $scope.accepts = []
  $scope.deleteThing = (index) ->
    console.log('in fun')
    if (Parse.User.current()?)
      Parse.User.current().fetch().then (user) ->
        console.log('in user fun')
        entry = $scope.accepts[index]
        $scope.accepts.splice(index, 1)
        userInvites = user.get 'Invite'
        result = (item for item in userInvites when item.inviteId != entry.inviteId)
        console.log(result)
        user.set 'Invite', result
        user.save null,
          error: (error) ->
        $scope.$apply()
        updateInvites()

  $scope.acceptInvite = (index) ->
    if(Parse.User.current()?)
      Parse.User.current().fetch().then (user) ->
        entry = $scope.invites[index]
        $scope.invites.splice(index, 1)
        User = Parse.Object.extend('User')
        query = new Parse.Query(User)
        userInvites = user.get 'Invite'
        result = (item for item in userInvites when item.inviteId == entry.inviteId)
        results = (item for item in userInvites when item.inviteId != entry.inviteId)
        if (result.length != 0)
          result[0].pending = false
          results.push result[0]
        console.log('Element: ' + result[0])
        console.log(results)
        user.set 'Invite', results
        user.save null, (error) ->
        $scope.$apply()

  $scope.deleteInvite = (index) ->
    if (Parse.User.current()?)
      Parse.User.current().fetch().then (user) ->
        entry = $scope.invites[index]
        $scope.invites.splice(index, 1)
        User = Parse.Object.extend('User')
        query = new Parse.Query(User)
        userInvites = user.get 'Invite'
        result = (item for item in userInvites when item.inviteId != entry.inviteId)
        console.log(result)
        user.set 'Invite', result
        user.save null,
          error: (error) ->
        $scope.$apply()
        updateInvites()



  updateInvites = ->
    $scope.invites = []
    $scope.accepts = []
    if (Parse.User.current()?)
      Parse.User.current().fetch().then (user) ->
        userInvites = user.get 'Invite'
        inviteIds = userInvites.map((invite) -> invite.inviteId)
        Invite = Parse.Object.extend('Invite')
        query = new Parse.Query(Invite)
        query.containedIn('objectId', inviteIds)
        query.find
          success: (invites) ->
            i = 0
            for invite in invites
              entry =
                title: (invite.get 'classTitle') + ' ' + (invite.get 'eventTitle')
                class: invite.get 'classTitle'
                from: invite.get 'from'
                location: invite.get 'location'
                date: (invite.get 'eventDate').toDateString()
                time: (invite.get 'eventDate').toTimeString()
                message: (invite.get 'description')
                inviteId: invite.id
              console.log(userInvites[i].pending)
              if (userInvites[i].pending)
                $scope.invites.push entry
              else
                $scope.accepts.push entry
              ++i
            $scope.$apply()
            return
          error: ->
  updateInvites()
