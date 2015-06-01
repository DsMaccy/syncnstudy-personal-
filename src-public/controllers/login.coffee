app.controller 'LoginCtrl', ($scope, $auth, $window, $alert, User) ->
  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password
    )
    .then((response) ->
      $auth.setToken(response.data.token)
      Parse.User.become(response.data.token)

      ##
      console.log(response.data.token)
      ##

      $window.location.href = '/'
      $alert(
        content: 'You have successfully logged in'
        animation: 'fadeZoomFadeDown'
        type: 'material'
        duration: 3
      )
    )
    .catch((response) ->
        $alert(
          content: response.data.message
          animation: 'fadeZoomFadeDown'
          type: 'material'
          duration: 3
        )
        $window.location.href = '#!/login'
    )
  $scope.authenticate = (provider) ->
    $auth.authenticate(provider)
      .then( ->
          $alert(
            content: 'You have successfully logged in',
            animation: 'fadeZoomFadeDown',
            type: 'material',
            duration: 3
          )
      )
      .catch((response) ->
        $alert(
          content: if response.data then response.data.message else response,
          animation: 'fadeZoomFadeDown',
          type: 'material',
          duration: 3
        )
      )
