app.controller 'LogoutCtrl', ($scope, $auth, $window) ->
  if !$auth.isAuthenticated then return else $auth.logout().then(-> $window.location.href = '/')
