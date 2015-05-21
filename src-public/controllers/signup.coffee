app.controller 'SignupCtrl', ($scope, $auth, $window) ->
  $scope.signup = ->
    $auth.signup(
      displayName: $scope.displayName,
      email: $scope.email,
      password: $scope.password
    )
    .catch((response) ->
        $window.location.href = '/'
    )
z