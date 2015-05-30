app.controller 'ClassesCtrl', ($scope) ->

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
  document.getElementById("demo").innerHTML = "";
  courseName = document.getElementById("course").value; #figure out form validation
  if courseName.length > 8 || courseName.length < 4
    alert "Please make to use the proper form, such as CHEM140A or CSE12!";
    return;
  schoolName = document.getElementById("university").value;
  schoolName = schoolName.toUpperCase();
  if schoolName != "UCSD"
      alert "Sorry, at the time we only support UCSD!";
      return;
  daysOfWeek = document.getElementById("days").value;
  if daysOfWeek.contains("/")
    alert "Please make sure you have the proper form Day/Day e.g.: M/W/F"
    return;
  classTime = document.getElementById("classtime").value;
  if !classTime.contains("-") || !classTime.contains(":")
    alert "Please make sure you have the proper form Time-Time e.g.: 12pm-12:50pm"
    return;
  seasonYear = document.getElementById("quarter").value;
  newClass = new Class(courseName, schoolName, daysOfWeek, classTime, seasonYear);
  newClass.numStudents = 1;
  alert "You just added #{courseName} and there is #{newClass.numStudents} student(s)."


addClass= () ->
  # #document.body.insertAdjacentHTML( 'lastclass', 'button.btn.btn-primary.btn-block CSE 140');
  # document.getElementById("lastclass").innerHTML = 'button.btn.btn-primary.btn-block CSE 140';
  tvalue = document.getElementById("cse140");
  tvalue.value++;
