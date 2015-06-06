app.controller 'ClassesCtrl', ($scope) ->

  Classes = Parse.Object.extend('Classes')

  ###
  Capture ONLY current user's course listing
  ###

  currUser = Parse.User.current() #get the current user
  enrolled = currUser.relation('enrolledClasses') #go get the current user's relation
  #console.log(enrolled) testing
  masterUserCourseArray = [] #declare the master array for all of the users courses

  userQuery = enrolled.query()
  userQuery.find
    success: (searchResult) ->
      j = 0
      #console.log('length is ' + searchResult.length)
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

        masterCourseArray.push courseArray

        i++
      $scope.courses = masterCourseArray
      $scope.$apply()


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
  console.log(classes)
  classes.save
    success: ->
      enrolled = Parse.User.current().relation('enrolledClasses') #go get the relation of curr user to classes
      enrolled.add classes #add the class in there
      Parse.User.current().save()
      location.reload()
      return

addClass= (event) ->
  #query for all the users classes.
  #If hes already in the class, cancel the add()
  temp = event.target.firstChild.nodeValue
  nameOfCourse = temp.split(" ")

  Classes = Parse.Object.extend('Classes')
  currentUser = Parse.User.current()
  query = new (Parse.Query)(Classes)

  query.equalTo 'title', nameOfCourse[1]

  query.first
    success: (object) ->

      object.increment 'numofstudents'

      enrolled = currentUser.relation('enrolledClasses') #go get the relation
      enrolled.add object #add the class in there

      currentUser.save()
      object.save()
      location.reload()

      return
    error: (error) ->
      alert 'Error: ' + error.code + ' ' + error.message
      return

dropClass= (event) ->

  ###
  removeClass = currUser.relation('enrolledClasses')
  userQuery = removeClass.query()
  ###

  temp = event.target.firstChild.nodeValue
  nameOfCourse = temp.split(" ")

  Classes = Parse.Object.extend('Classes')

  currentUser = Parse.User.current()
  query = new (Parse.Query)(Classes)

  query.equalTo 'title', nameOfCourse[1]

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

