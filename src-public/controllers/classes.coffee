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
  courseName = document.getElementById("course").value;
  schoolName = document.getElementById("university").value;
  daysOfWeek = document.getElementById("days").value;
  classTime = document.getElementById("classtime").value;
  seasonYear = document.getElementById("quarter").value;
  newClass = new Class(courseName, schoolName, daysOfWeek, classTime, seasonYear);
  newClass.numStudents = 1;
  alert "You just added #{courseName} and there is #{newClass.numStudents} student(s)."


addClass= () ->
  # #document.body.insertAdjacentHTML( 'lastclass', 'button.btn.btn-primary.btn-block CSE 140');
  # document.getElementById("lastclass").innerHTML = 'button.btn.btn-primary.btn-block CSE 140';
  tvalue = document.getElementById("cse140");
  tvalue.value++;
