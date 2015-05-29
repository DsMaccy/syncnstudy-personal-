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
  constructor: (@name, @school, @students, @numStudents, @date, @time, @quarter)->
toggle1= () ->
  document.getElementById("page1").setAttribute("style","display:none");
  document.getElementById("page2").setAttribute("style","display:block");

toggle2= () ->
  document.getElementById("page2").setAttribute("style","display:none");
  document.getElementById("page1").setAttribute("style","display:block");

