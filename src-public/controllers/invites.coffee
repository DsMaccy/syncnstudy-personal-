app.controller 'InvitesCtrl', ($scope) ->
  $scope.invites = []
  $scope.accepts = []

  $scope.acceptInvite = (index) ->


  $scope.deleteInvite = (index) ->
    if (Parse.User.current()?)
      Parse.User.current().fetch().then (user) ->
        console.log('in user fun')
        entry = $scope.invites.splice(index, 1)
        User = Parse.Object.extend('User')
        query = new Parse.Query(User)
        query.equalTo('classTitle', entry.class)
        query.find
          success: (users) ->
            user = users[0]
            console.log('in success fun')
            userInvites = user.get 'Invite'
            result = (item for item in userInvites when item.inviteId != entry.inviteId)[0]
            console.log(result)
            user.set 'Invite', result
            user.save()
          error: ->

  if (Parse.User.current()?)
    Parse.User.current().fetch().then (user) ->
      userInvites = user.get 'Invite'
      inviteIds = userInvites.map((invite) -> invite.inviteId)
      Invite = Parse.Object.extend('Invite')
      query = new Parse.Query(Invite)
      query.containedIn('objectId', inviteIds)
      query.find
        success: (invites) ->
          for invite in invites
            entry =
              title: (invite.get 'classTitle') + ' ' + (invite.get 'eventTitle')
              class: invite.get 'classTitle'
              from: invite.get 'from'
              location: invite.get 'location'
              date: (invite.get 'eventDate').toDateString()
              time: (invite.get 'eventDate').toTimeString()
              message: (invite.get 'description')
              invideId: invite.get 'objectId'
            if (userInvites.pending)
              $scope.invites.push entry
            else
              $scope.invites.push entry
          $scope.$apply()
          return
        error: ->
