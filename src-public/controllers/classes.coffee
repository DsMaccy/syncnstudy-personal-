app.controller 'ClassesCtrl', ($scope) ->

  Classes = Parse.Object.extend('Classes')

  ###
  Capture ONLY current user's course listing
  ###

  currUser = Parse.User.current() #get the current user
  enrolled = currUser.relation('enrolledClasses') #go get the current user's relation
  masterUserCourseArray = [] #declare the master array for all of the users courses

  userQuery = enrolled.query()
  userQuery.find
    success: (searchResult) ->
      j = 0
      while j < searchResult.length
        #code stuff
        oneClass = searchResult[j]

        userCourseArray = []
        userCourseArray['CourseId'] = oneClass.get 'objectId'
        userCourseArray['CourseName'] = oneClass.get 'title'
        userCourseArray['Dates'] = oneClass.get 'weeklysessiondays'
        userCourseArray['Time'] = oneClass.get 'time'
        userCourseArray['Students'] = oneClass.get 'numofstudents'
        userCourseArray['Remove'] = 'Remove'
        userCourseArray['objectId'] = oneClass.id


        masterUserCourseArray.push userCourseArray

        j++
      $scope.userCourses = masterUserCourseArray
      $scope.$apply()
  ###
  Remove relation from current users class relation
  ###


  ###
  Capture ALL course listings
  ###
  query = new (Parse.Query)(Classes)
  masterCourseArray = []
  query.find
    success: (results) ->

      i = 0
      while i < results.length

        object = results[i]

        courseArray = []
        courseArray['CourseName'] = object.get 'title'
        courseArray['Dates'] = object.get 'weeklysessiondays'
        courseArray['Time'] = object.get 'time'
        courseArray['Students'] = object.get 'numofstudents'
        courseArray['Add'] = 'Add'
        courseArray['objectId'] = object.id

        masterCourseArray.push courseArray

        i++
      masterCourseArray.sort(sortFunction)
      $scope.courses = masterCourseArray
      $scope.$apply()

####                          END OF APP.CONTROLLER                               ####





app.filter('searchFor', ()->
  return (arr, searchString)->
    if(!searchString)
      return arr;
    result = [];
    searchString = searchString.toUpperCase()
    angular.forEach(arr, (course) ->
      if course.CourseName.toUpperCase().indexOf(searchString) != -1
        result.push(course)
    )
    return result
)

#Search function for displaying classes by student
sortFunction= (a,b) ->
  if a['Students'] < b['Students']
    return 1
  if a['Students'] > b['Students']
    return -1


class Class
  constructor: (@name, @school, @date, @time, @quarter)->
    numStudents: 0
    students: 0



toggle1= () ->
  document.getElementById("page1").setAttribute("style","display:none");
  document.getElementById("page2").setAttribute("style","display:block");

toggle2= () ->

  document.getElementById("page2").setAttribute("style","display:none");
  document.getElementById("page1").setAttribute("style","display:block");
  #document.getElementById("demo").innerHTML = "";
  errorMessage = "";
  courseName = document.getElementById("course").value; #figure out form validation
  if courseName.length > 8 || courseName.length < 4
    errorMessage += "Please make to use the proper form, such as CHEM140A or CSE12! \n";
  schoolName = document.getElementById("university").value;
  schoolName = schoolName.toUpperCase();
  if schoolName != "UCSD"
    errorMessage += "Sorry, at the time we only support UCSD! \n";
  daysOfWeek = document.getElementById("days").value;
  #if daysOfWeek.contains("/")
  # errorMessage += "Please make sure you have the proper form Day/Day e.g.: M/W/F"
  classTime = document.getElementById("classtime").value;
  #if !classTime.contains("-") || !classTime.contains(":")
  # errorMessage += "Please make sure you have the proper form Time-Time e.g.: 12pm-12:50pm"
  seasonYear = document.getElementById("quarter").value;

  if errorMessage != ""
    alert errorMessage;
    document.getElementById("page1").setAttribute("style","display:none");
    document.getElementById("page2").setAttribute("style","display:block");
    return;


  newClass = new Class(courseName, schoolName, daysOfWeek, classTime, seasonYear);
  newClass.numStudents = 1;

  alert "You just added #{courseName} and there is #{newClass.numStudents} student(s)."
  para = document.createElement("P");
  line = document.createElement("HR");
  concat = "#{courseName} " + "#{seasonYear} " + "#{daysOfWeek} " + "#{classTime} ";
  text = document.createTextNode(concat);
  para.appendChild(text);
  para.appendChild(line);
  #document.getElementById("userclasses").appendChild(para);

  #Parse stuff
  Classes = Parse.Object.extend('Classes')
  classes = new Classes

  classes.set 'title', courseName
  classes.set 'university', schoolName
  classes.set 'weeklysessiondays', daysOfWeek
  classes.set 'time', classTime
  classes.set 'session', seasonYear
  classes.set 'numofstudents', 1
  classes.save(null, {
      success: ->
        enrolled = Parse.User.current().relation('enrolledClasses') #go get the relation of curr user to classes
        enrolled.add classes #add the class in there
        Parse.User.current().save()
        location.reload()
        return
    })



# onclick function for the add class button
addClass = (event) ->
  classObjectId = event.target.id

  Classes = Parse.Object.extend('Classes')
  currentUser = Parse.User.current()
  query = new (Parse.Query)(Classes)

  query.equalTo 'objectId', classObjectId

  query.first
    success: (object) ->


      enrolled = currentUser.relation('enrolledClasses') #go get the relation
      classQuery = enrolled.query() # check if relation exists
      classQuery.equalTo('objectId', object.id)
      classQuery.find({
        success: (classInQuestion) ->
          if !classInQuestion or classInQuestion.length == 0
            object.increment 'numofstudents'
            enrolled.add object #add the class in there

            currentUser.save()
            object.save()
            location.reload()
          else
            alert ("You are already enrolled in this class")
            ###
            $alert(
              content: "You are already enrolled in this class"
              animation: 'fadeZoomFadeDown'
              type: 'material'
              duration: 3
            )###
      })
      #if ()


      return
    error: (error) ->
      alert 'Error: ' + error.code + ' ' + error.message
      return

# onclick function for the remove class button
dropClass = (event) ->

  Classes = Parse.Object.extend('Classes')
  currentUser = Parse.User.current()
  classObjectId = event.target.id

  query = new (Parse.Query)(Classes)
  query.equalTo 'objectId', classObjectId

  query.first
    success: (object) ->

      object.increment 'numofstudents', -1
      drop = currentUser.relation("enrolledClasses")
      drop.remove object #drop the class in there

      currentUser.save()
      object.save()
      location.reload()

      return
    error: (error) ->
      alert 'Error: ' + error.code + ' ' + error.message
      return

