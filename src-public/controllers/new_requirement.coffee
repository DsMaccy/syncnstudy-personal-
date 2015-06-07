# Author: Dylan McNamara

fillClassDropDown = undefined
addDropDown = undefined



fillClassDropDown = ($scope) ->

  user = Parse.User.current()
  relation = user.relation('enrolledClasses')
  $scope.classes = []

  relation.query().find({
    success: (list) ->
      if list.length == 0
        document.getElementById("bottom").setAttribute('disabled',true)
        alert("You have not enrolled in any classes")
      else
        $scope.classes.push({
          CourseName: result.get('title')
          Dates: result.get('weeklysessiondays')
          Time: result.get('time')
          index: $scope.classes.length
          objId: result.id
        }) for result in list
        $scope.$apply()
    error: (error) ->
      console.error(error)
  })

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
  #eventList = classParseObject.get('eventlist')
  Event = Parse.Object.extend('Event')
  eventQuery = new Parse.Query(Event)
  eventQuery.equalTo('isClassEvent',true)
  eventQuery.equalTo('title',title)
  eventQuery.equalTo('numassignment',number)
  eventQuery.first({
    success: (obj) ->
      if obj == undefined
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

eventDoesNotExist = (classParseObject) ->
  ClassEvent = Parse.Object.extend('Event')
  newCE = new ClassEvent()
  timeOfEvent = getDate()
  endTime = getDate()
  endTime.setHours(timeOfEvent.getHours() + 1)

  newCE.set({
      startsAt: timeOfEvent,
      endsAt: endTime, # THIS HAS BEEN CAUSING AN ERROR
      location: classParseObject.get('title'),
      message: document.getElementById('description').value,
      title: document.getElementById('title').value,
      numassignment: parseInt(document.getElementById('num').value),
      isClassEvent: true,
      type: "important"
    },
    {
      error: (currentUsr, error) ->
        console.error("There was an issue updating the information")
    })
  newCE.save(null,
    {
      success: (newCE) ->
        user = Parse.User.current()

        userRelation = user.relation('classEvents')
        classRelation = classParseObject.relation('classevents')

        userRelation.add(newCE)
        classRelation.add(newCE)

        #classParseObject.add('eventlist', newCE.id)
        classParseObject.save(null, {
          success: (obj) ->
            user.save({
              error: (error) ->
                console.error(error)
            })
            alert("New class event has been created successfully")
            #TODO: Uncomment this line of code
            window.location.assign("#!/home")
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