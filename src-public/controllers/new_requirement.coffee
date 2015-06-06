# Author: Dylan McNamara

fillClassDropDown = undefined
addDropDown = undefined



fillClassDropDown = ($scope) ->
  classArray = Parse.User.current().get('Classes')
  $scope.classes = []
  if classArray.length != 0
    Classes = Parse.Object.extend("Classes")
    classQuery = new Parse.Query(Classes)
    classQuery.get(classObjId, {
      success : (result) ->
        $scope.classes.push({
          CourseName: result.get('title')
          Dates: result.get('weeklysessiondays')
          Time: result.get('time')
          index: $scope.classes.length
          objId: result.id
          })
      error: (error) ->
        classArray.remove(classObjId)
        console.error('nothing found')
        console.error(error)
      })for classObjId in classArray
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
    newOption.setAttribute('value', i-1)
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

getDate = () ->
  returnObj = new Date()
  returnObj.setDate(parseInt(document.getElementById("day").value))
  returnObj.setMonth(parseInt(document.getElementById("month").value))
  returnObj.setFullYear(parseInt(document.getElementById("year").value))
  am_pm = parseInt(document.getElementById("dn").value)
  returnObj.setHours(parseInt(document.getElementById("hour").value) +
    12 * am_pm)
  returnObj.setMilliseconds(0)
  returnObj.setMinutes(parseInt(document.getElementById("min").value))

  console.log(returnObj.getMonth())
  console.log(returnObj.toString())

  return returnObj

################   PARSE STUFF BELOW   ################

checkValid = (event, title, number) ->
  if (event.get("isClassEvent"))
    if(event.get("title") == title)
      if (event.get("numassignment") == number)
        return true
  return false


# Checks if the class already contains the class event
#TODO fill in this method
checkIfEventExists = (classParseObject, title, number) ->
  eventList = classParseObject.get('eventlist')
  console.log("We're in")
  Event = Parse.Object.extend('Event')
  eventQuery = new Parse.Query(Event)
  eventQuery.equalTo('isClassEvent',true)
  eventQuery.equalTo('title',title)
  eventQuery.equalTo('numassignment',number)
  #eventQuery.equalTo('numassignment',number+1)
  eventQuery.first({
    success: (obj) ->
      if obj == undefined
        #TODO Have it push shit to parse
        console.log("holy shit here we go")
        eventDoesNotExist(classParseObject)
      else
        eventDoesExist()
    error: (error) ->
      console.error("Trouble finding the class List")
      console.error(error)
  })

eventDoesExist = () ->
  alert("This event has already been created for the class")
# Method gets called when the "Send" button gets pushed

eventDoesNotExist = (result) ->
  ClassEvent = Parse.Object.extend('Event')
  newCE = new ClassEvent()

  timeOfEvent = getDate()

  newCE.set({
      datedue: timeOfEvent,
      description: document.getElementById('description').value
      title: document.getElementById('title').value
      numassignment: parseInt(document.getElementById('num').value)
      isClassEvent: true
    },
    {
      error: (currentUsr, error) ->
        console.error("There was an issue updating the information")
    })
  newCE.save(null,
    {
      success: (newCE) ->
        result.add('eventlist', newCE.id)
        result.save(null, {
          success: (obj) ->
            alert("New class event has been created successfully")
  #window.location.assign("#!/home")
          error: (error) ->
            alert("There was an issue saving the data to the server.  We apologize for the inconvenience :(")
            console.error(error)
        })
    })

updateClassEvent = () ->
  # Gather and save data to a new Event object

  Classes = Parse.Object.extend('Classes')
  classQuery = new Parse.Query(Classes)

  classQuery.get(document.getElementById('classList').value, {
    success: (result) ->
      #TODO Verify correct value of Date is being pushed to the database

      checkIfEventExists(result, document.getElementById('title').value, parseInt(document.getElementById('num').value))

    error: (error) ->
      console.error(error)
      alert("Unexpected Error. Unable to save event")
  })
# Create and save event object


################   APP CONTROLLER   ################

app.controller 'NewReqCtrl', ($scope, $auth, $alert) ->
  fillTimeDropDown()
  Parse.User.become($auth.getToken())
  fillClassDropDown($scope)