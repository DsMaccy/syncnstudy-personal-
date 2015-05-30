app.controller 'ResetPasswordCtrl', ($scope, $auth, $window, Test) ->
  $scope.resetPassword = ->
    $window.location.href = '#!/'
