app.controller 'LoginCtrl', ($scope, $auth, $window, $alert, $rootScope) ->
  $scope.login = ->
    $auth.login(
      email: $scope.email
      password: $scope.password
    )
    .catch((response) ->
        $rootScope.user = response.data.userThing
        $window.location.href = '/'
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
