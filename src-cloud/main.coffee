require 'cloud/app.js'

Parse.Cloud.afterSave 'Invite', (request) ->
  Parse.Cloud.useMasterKey()
  User = Parse.Object.extend('User')
  query = new (Parse.Query)(User)
  query.containedIn('username', request.object.get 'invitedList')
  console.log(request.object.get 'invitedList')
  query.find
    success: (users) ->
      for user in users
        user.addUnique 'Invite', request.object.id
        user.save()
    error: ->
###
Parse.Cloud.beforeSave "Task", (request, response) ->
  request.object.set "random", Math.floor((Math.random() * 100) + 1)
  response.success()
  return
###
