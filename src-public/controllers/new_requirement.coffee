fillClassDropDown = undefined
addDropDown = undefined



fillClassDropDown = ($scope) ->
  classArray = Parse.User.current().get('Classes')
  $scope.classes = []
  if classArray.length = 0
    document.getElementById("bottom").setAttribute('disabled',false)
    Classes = Parse.Object.extend("Classes")
    classQuery = new Parse.Query(Classes)
    classQuery.get(classObjId, {
      success : (result) ->
        $scope.classes.push({
          CourseName: result.get('title')
          Dates: result.get('weeklysessiondays')
          Time: result.get('time')
          index: $scope.classes.length
          })
      error: (error) ->
        console.log('nothing found')
        console.log(error)
      })for classObjId in classArray
    console.log($scope.classes)
  else # this part works correctly
    document.getElementById("bottom").setAttribute('disabled',true)
    alert("You have not enrolled in any classes")

# Fill in various select fields for the date and time
fillTimeDropDown = () ->
  # Fill hours and months
  i = 1
  while i <= 12
    newOption = document.createElement("option")
    newOption.innerHTML = i
    newOption.setAttribute('value', i)
    document.getElementById('hour').appendChild(newOption)

    newOption = document.createElement("option")
    newOption.innerHTML = i
    newOption.setAttribute('value', i)
    document.getElementById('month').appendChild(newOption)
    i++

  # Fill minutes
  i = 0
  while i <= 59
    newOption = document.createElement("option")
    newOption.innerHTML = i
    newOption.setAttribute('value', i)
    document.getElementById('min').appendChild(newOption)
    i += 5

  # Fill days
  i = 1
  while i <= 31
    newOption = document.createElement("option")
    newOption.setAttribute('value', i)
    newOption.innerHTML = i
    document.getElementById('day').appendChild(newOption)
    i++

  # Fill in years
  i = 0
  currentDate = new Date()
  while i < 2
    newOption = document.createElement("option")
    newOption.innerHTML = i + currentDate.getFullYear()
    newOption.setAttribute('value', i + currentDate.getFullYear())
    document.getElementById('year').appendChild(newOption)
    i++

# Modify the number of days when a new month is set
changeNumDays = () ->
  currentSelection = parseInt(document.getElementById('day').value)
  MoY = document.getElementById('month').value
  MoY = parseInt(MoY)
  resetDayField()
  if MoY == 9 or MoY == 4 or MoY == 6 or MoY == 11
    i = 1
    while i <= 30
      newOption = document.createElement("option")
      newOption.setAttribute('value', i)
      newOption.innerHTML = i
      document.getElementById('day').appendChild(newOption)
      i++
    if currentSelection <= 30
      document.getElementById("day").selectedIndex = currentSelection - 1
  else if MoY == 2
    console.log("29")
    i = 1
    while i <= 29
      newOption = document.createElement("option")
      newOption.setAttribute('value', i)
      newOption.innerHTML = i
      document.getElementById('day').appendChild(newOption)
      i++
    if currentSelection <= 29
      document.getElementById("day").selectedIndex = currentSelection - 1
  else
    i = 1
    while i <= 31
      newOption = document.createElement("option")
      newOption.setAttribute('value', i)
      newOption.innerHTML = i
      document.getElementById('day').appendChild(newOption)
      i++
    document.getElementById("day").selectedIndex = currentSelection - 1

resetDayField = () ->
  myNode = document.getElementById('day')
  while (myNode.firstChild)
    myNode.removeChild(myNode.firstChild)




addDropDown = (classObj) ->
  newOption = document.createElement("select")
  newOption.innerHTML = classObj.get('title')
  newOption.setAttribute('value', classObject.get('objectId'))
  document.getElementById('classList').addChild(newOption)

# Checks if the class already contains the class event
#TODO fill in this method
eventExists = (title, number) ->
  return false

# Returns Parse.Object
findClass = () ->
  Classes = Parse.Object.extend("Classes")
  queryClasses = new Parse.Query(Classes)
  queryClasses.equalTo('objectId', document.getElementById('classList').value)
  return query.get(document.getElementById('classList').value)

# Method gets called when the "Send" button gets pushed
updateClassEvent = () ->
  # Gather and save data to a new Event object

  d = parseInt(document.getElementById("day").value)
  mo = parseInt(document.getElementById("month").value)
  y = parseInt(document.getElementById("year").value)
  ampm = parseInt(document.getElementById("dn").value)
  h = parseInt(document.getElementById("hour").value) +
    12*ampm
  mi = parseInt(document.getElementById("min").value)


  timeOfEvent = new Date(y, mo, d, h, mi)
  console.log(timeOfEvent)
  console.log(timeOfEvent.getMonth())
  ClassEvent = new Parse.Object.extend('Event')
  newCE = new ClassEvent()


  if exists(document.getElementById('title').value,
    parseInt(document.getElementById('num').value))
    alert("This event has already been recorded for the class")
  else
    newCE.set({
        datedue: timeOfEvent,
        description: document.getElementById('description').value
        title: document.getElementById('description').value
        numassignment: document.getElementById('num').value
      },
      {
        error: (currentUsr, error) ->
          console.log("There was an issue updating the information")
      })

    newCE.save(null,
      {
        success: (currentUsr) ->
          alert("New class event has been successfully created")
        error: (currentUsr, error) ->
          console.log("There was an issue saving the data to the server.  We apologize for the inconvenience :(")
          console.log(error)
      })

    # Save this information to the class array

    findClass().get('eventlist').add(newCE.get('objectId'))


app.controller 'NewReqCtrl', ($scope, $auth, $alert) ->
  fillTimeDropDown()
  Parse.User.become($auth.getToken())
  fillClassDropDown($scope)
  #$scope.$apply()
  console.log($scope.classes)