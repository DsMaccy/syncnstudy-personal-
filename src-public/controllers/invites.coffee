app.controller 'InvitesCtrl', ($scope) ->
  $scope.invites = [
    {
      title: 'Cse 140 Study Group'
      class: 'CSE 140'
      from: 'Timmy Ngo'
      location: 'B240'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Hey buddy we should go study'
      deletable: true
    }
    {
      title: 'Cse 110 Project'
      class: 'CSE 110'
      from: 'Gabe Maze-Rogers'
      location: 'Geisel'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Gary is so cool'
      deletable: true
    }
    {
      title: 'Cse 3 Final Homework'
      class: 'CSE 3'
      from: 'Paul Hoang'
      location: 'The loft'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Pls help'
      deletable: true
    }
  ]
  $scope.accepts = [
    {
      title: 'Cse 110 Group meeting'
      class: 'CSE 140'
      from: 'Timmy Ngo'
      location: 'B240'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Hey buddy we should go study'
      deletable: true
    }
    {
      title: 'Cse 140 Lab'
      class: 'CSE 110'
      from: 'Gabe Maze-Rogers'
      location: 'Geisel'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Gary is so cool'
      deletable: true
    }
    {
      title: 'Cse 3 Lab'
      class: 'CSE 3'
      from: 'Paul Hoang'
      location: 'The loft'
      date: '10/20/15'
      time: '12:00pm - 1:50pm'
      message: 'Pls help'
      deletable: true
    }
  ]
