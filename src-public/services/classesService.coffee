# Provide fetchClasses with a callBack function that accepts one parameter,
# an object.  If you are updating scope variables don't forget to use
# $scope.$apply()
app.factory 'classesService', ->
  fetchClasses: (callBack) ->
    Classes = Parse.Object.extend('Classes')
    query = new (Parse.Query)(Classes)
    query.find(
      success: (object) ->
        callBack(object)
        return
      error: (error) ->
        alert 'Error: ' + error.code + ' ' + error.message
        return
    )
