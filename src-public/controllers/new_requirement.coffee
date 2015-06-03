fillClassDropDown = undefined
addDropDown = undefined



fillClassDropDown = () ->
  classArray = Parse.User.current().get('Classes')
  addDropDown classObj for classObj in classArray

fillTimeDropDown = () ->
  console.log('MOTHA FUCKA')
  i = 1
  while i <= 12
    newOption = document.createElement("option")
    newOption.innerHTML = i
    document.getElementById('hour').appendChild(newOption)
    i++
  i = 0
  while i <= 59
    newOption = document.createElement("option")
    newOption.innerHTML = i
    document.getElementById('min').appendChild(newOption)
    i+=5


addDropDown = (classObj) ->
  newOption = document.createElement("select")
  newOption.innerHTML = classObj.get('title')
  document.getElementById('classList').addChild(newOption)



validateYear = () ->


app.controller 'NewReqCtrl', ($scope, $auth, $alert) ->
  fillTimeDropDown()
  Parse.User.become($auth.getToken())
  fillClassDropDown()