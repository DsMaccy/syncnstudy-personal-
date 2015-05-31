app.controller 'SignupCtrl', ($scope, $auth, $window) ->
  $scope.signup = ->
    $auth.signup(
      displayName: $scope.displayName,
      email: $scope.email,
      password: $scope.password
    )
    .then((response) ->
      $auth.setToken(response.data.token)
      Parse.User.become(response.data.token)
      $window.location.href = '/'
      $alert(
        content: 'You have successfully signed up'
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
        $window.location.href = '#!/signup'
    )
