app.controller 'ClassesCtrl', ($scope) ->

  #Author: Gabe Maze-Rogers
###
  name: String - class name
  school: String - university name
  students: Array of user objects - Students in class
  numStudents: Int - num of Students in class
  date: String - When the class is.. Format M/W/F or Tu/Th etc.
  time: String - When the class is.. Format 1p-1:50p etc.
###
class Class
  constructor: (@name, @school, @students, @numStudents, @date, @time)->
