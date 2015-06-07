app.controller 'InvitesCtrl', ($scope) ->
  $scope.invites = []
  $scope.accepts = []
  $scope.deleteThing = (index) ->
    user = Parse.User.current()
    userInvites = user.get 'Invite'
    entry = $scope.accepts[index]
    result = (item for item in userInvites when item.inviteId == entry.inviteId)
    user.remove('Invite', result[0])
    user.save(null, {
      success: () ->
        $scope.$apply()
        updateInvites()
      error: (error) ->
        console.error(error)
    })


  $scope.acceptInvite = (index) ->


    user = Parse.User.current()
    userInvites = user.get 'Invite'

    entry = $scope.invites[index]

    result = (item for item in userInvites when item.inviteId == entry.inviteId)

    user.remove('Invite', result[0])



    newObject = {
      inviteId: entry.inviteId
      pending: false
    }
    user.save(null,{
      error: (error) ->
        console.error(error)
    })

    user.add('Invite', newObject)

    user.save(null,{
      error: (error) ->
        console.error(error)
    })

    updateInvites()



  $scope.deleteInvite = (index) ->

    user = Parse.User.current()
    userInvites = user.get 'Invite'

    entry = $scope.invites[index]

    result = (item for item in userInvites when item.inviteId == entry.inviteId)

    user.remove('Invite', result[0])
    user.save(null, {
      success: () ->
        $scope.$apply()
        updateInvites()
      error: (error) ->
        console.error(error)
    })

  updateInvites = ->
    $scope.invites = []
    $scope.accepts = []
    Parse.User.current().fetch().then (user) ->

      userInvites = user.get("Invite")
      console.log(userInvites)
      if !userInvites
        return
      Invite = Parse.Object.extend('Invite')
      query = new Parse.Query(Invite)
      for userInvite in userInvites
        if userInvite.pending
          query.equalTo('objectId', userInvite.inviteId)
          query.find
            success: (invite) ->
              invite = invite[0]
              if invite
                entry =
                  title: (invite.get 'classTitle') + ' ' + (invite.get 'eventTitle')
                  class: invite.get 'classTitle'
                  from: invite.get 'from'
                  location: invite.get 'location'
                  date: (invite.get 'eventDate').toDateString()
                  time: (invite.get 'eventDate').toTimeString()
                  message: (invite.get 'description')
                  inviteId: invite.id
                $scope.invites.push entry
                $scope.$apply()
        else
          query.equalTo('objectId', userInvite.inviteId)
          query.find
            success: (invite) ->
              invite = invite[0]
              if invite
                entry =
                  title: (invite.get 'classTitle') + ' ' + (invite.get 'eventTitle')
                  class: invite.get 'classTitle'
                  from: invite.get 'from'
                  location: invite.get 'location'
                  date: (invite.get 'eventDate').toDateString()
                  time: (invite.get 'eventDate').toTimeString()
                  message: (invite.get 'description')
                  inviteId: invite.id
                $scope.accepts.push entry
                $scope.$apply()
      $scope.$apply()

  updateInvites()
