app.factory 'ParseUtils', ->
  # Provide fetchObject with a objectName and callBack function that accepts
  # one parameter,an object.  If you are updating scope variables don't forget
  # to use $scope.$apply()
  fetchObject: (objectName, callBack) ->
    Obj = Parse.Object.extend(objectName)
    query = new (Parse.Query)(Obj)
    query.find(
      success: (object) ->
        callBack(object)
        return
      error: (error) ->
        alert 'Error: ' + error.code + ' ' + error.message
        return
    )
