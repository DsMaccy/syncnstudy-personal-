app.controller 'ResetPasswordCtrl', ($scope, $auth, $window, Test) ->
  newTest = new Test()
  newTest.set('yolo', '')
  $scope.resetPassword = ->
    $window.location.href = '#!/'
