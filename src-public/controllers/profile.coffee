app.controller "ProfileCtrl", ($scope,$auth) ->

changeSize = undefined

changeSize = (pxSize) ->
  document.getElementById('avatarimg').style.height = pxSize
  document.getElementById('avatarimg').style.width = pxSize
  document.getElementById('avatarimg').src = 'https://consequenceofsound.files.wordpress.com/2014/05/kanye-west.jpg?w=1200'