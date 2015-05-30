'use strict'

app = angular.module 'angularParseBoilerplate', [
  'ng'
  'ngResource'
  'ui.router'
  'ui.bootstrap'
  'app.templates'
  'Parse'
  'angulartics'
  'angulartics.google.analytics'
  'satellizer'
  'mgcrea.ngStrap'
  'mwl.calendar'
]

app.config (
  $locationProvider
  $stateProvider
  $urlRouterProvider
  $authProvider
) ->

  $locationProvider.hashPrefix '!'

  $stateProvider
  .state 'login',
    url: '/login',
    controller: 'LoginCtrl'
    templateUrl: 'login.html'
  .state 'logout',
    url: '/logout'
    controller: 'LogoutCtrl'
    templateUrl: 'home.html'
  .state 'home', {
    url: '/'
    views: {
      '':
        templateUrl: 'home.html'
        controller: 'HomeCtrl',
      'calendar@home':
        templateUrl: 'calendar.html'
        controller: 'CalendarCtrl',
      'signup@home':
        templateUrl: 'signup.html'
        controller: 'SignupCtrl',
      'about@home':
        templateUrl: 'about.html'
        controller: 'AboutCtrl'
    }
  }
  .state 'profile',
    url: '/profile'
    controller: 'ProfileCtrl'
    templateUrl: 'profile.html'
  .state 'classes',
    url: '/classes'
    controller: 'ClassesCtrl'
    templateUrl: 'classes.html'
  .state 'signup',
    url: '/signup'
    controller: 'SignupCtrl'
    templateUrl: 'signup.html'
  .state 'invites',
    url: '/invites'
    controller: 'InvitesCtrl'
    templateUrl: 'invites.html'
  .state 'terms_and_conditions',
    url: '/terms_and_conditions'
    controller: 'TermsCondCtrl'
    templateUrl: 'terms_and_conditions.html'
  .state 'privacypolicy',
    url: '/privacypolicy'
    controller: 'PrivacyPolicyCtrl'
    templateUrl: 'privacypolicy.html'
  .state 'reset_password',
    url: '/reset_password'
    controller: 'ResetPasswordCtrl'
    templateUrl: 'reset_password.html'
  .state 'addclass',
    url: '/addclass'
    controller: 'AddClassCtrl'
    templateUrl: 'addclass.html'

  $urlRouterProvider.otherwise '/'

  $authProvider.google(
    clientId: '893059616848-cut5s8vmq30stksu1k96fssu20gtcoq8.apps.googleusercontent.com'
  )

app.run ($rootScope, $state) ->
  $rootScope.$state = $state
