app.controller 'ClassesCtrl', ($scope) ->


  Classes = Parse.Object.extend('Classes')
  query = new (Parse.Query)(Classes)

  #query for all the users classes.
  #If hes already in the class, cancel the add()
  #idk how to loop
  #query.equalTo 'session', 'Spring 2015'
  j = 0
  while j < 4
    query.skip j
    query.find
      success: (results) ->

        i = 0
        while i < results.length
          object = results[i]
          $scope.courses = [
            {
              CourseName: object.get 'title'
              Dates: object.get 'weeklysessiondays'
              Time: object.get 'time'
              Students: object.get 'numofstudents'
              Add: 'Add'
            }
          ]
          i++

        return
      error: (error) ->
        alert 'Error: ' + error.code + ' ' + error.message
        return
    j++


###
      num = object.get 'numofstudents'
      alert 'Successfully retrieved ' + num + ' students.'
      object.increment 'numofstudents'
      object.save()
      num = object.get 'numofstudents'
      alert 'Incremented nos by 1:  ' + num + ' students.'


      return
    error: (error) ->
      alert 'Error: ' + error.code + ' ' + error.message
      return
  $scope.courses = [

    {
      CourseName: 'CSE 140'
      Dates: 'M/W/F'
      Time: '12-12:50pm'
      Students: '0'
      Add: 'Add'
    }
    {
      CourseName: 'CSE 130'
      Dates: 'M/W/F'
      Time: '3-3:50pm'
      Students: '2'
      Add: 'Add'
    }
    {
      CourseName: 'CSE 110'
      Dates: 'Tu/Th'
      Time: '5-6:20pm'
      Students: '12'
      Add: 'Add'
    }
  ]
###
#Author: Gabe Maze-Rogers
###
  name: String - class name
  school: String - university name
  students: Array of user objects - Students in class
  numStudents: Int - num of Students in class
  date: String - When the class is.. Format M/W/F or Tu/Th etc.
  time: String - When the class is.. Format 1p-1:50p etc.
  quarter: String - Semester etc. ex Spring 2015
###
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
  document.getElementById("userclasses").appendChild(para);


  #Parse stuff
  Classes = Parse.Object.extend('Classes')
  classes = new Classes

  classes.set 'title', courseName
  classes.set 'university', schoolName
  classes.set 'weeklysessiondays', daysOfWeek
  classes.set 'time', classTime
  classes.set 'session', seasonYear
  classes.set 'numofstudents', 1
  classes.save()

addClass= () ->
# #document.body.insertAdjacentHTML( 'lastclass', 'button.btn.btn-primary.btn-block CSE 140');
# document.getElementById("lastclass").innerHTML = 'button.btn.btn-primary.btn-block CSE 140';
  tvalue = document.getElementById("cse140");
  tvalue.value++;


  #update parse value numOfStudents
  Classes = Parse.Object.extend('Classes')
  query = new (Parse.Query)(Classes)
  query.equalTo 'title', 'CSE140'

  #query for all the users classes.
  #If hes already in the class, cancel the add()

  query.first
    success: (object) ->

      num = object.get 'numofstudents'
      alert 'Successfully retrieved ' + num + ' students.'
      object.increment 'numofstudents'
      object.save()
      num = object.get 'numofstudents'
      alert 'Incremented nos by 1:  ' + num + ' students.'


      return
    error: (error) ->
      alert 'Error: ' + error.code + ' ' + error.message
      return
