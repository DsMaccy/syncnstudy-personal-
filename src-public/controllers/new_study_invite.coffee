app.controller 'StudyInvCtrl', ($scope, $auth, $alert, $window) ->
  $scope.hours = [12..0]
  $scope.minutes = [59..0]
  $scope.sendInvite = (invite) ->
    Invite = Parse.Object.extend('Invite')
    newInvite = new Invite()
    newInvite.set('classTitle', invite.classTitle)
    newInvite.set('description', invite.description)
    newInvite.save()
  $scope.classes = []
  init = ->
    Event = Parse.Object.extend('Classes')
    query = new (Parse.Query)(Event)
    gah = []
    query.find(
      success: (object) ->
        blah = []
        for aClass in object
          title = (aClass.get 'title')
          blah.push title
        $scope.classes = blah
        $scope.$apply()
        console.log(blah)
        return
      error: (error) ->
        alert 'Error: ' + error.code + ' ' + error.message
        return ['test']
    )

  init()
    #$window.location.href = '#!/new_study_invite'
