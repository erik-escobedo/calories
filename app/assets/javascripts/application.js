// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require angular/angular.min
//= require angular-bootstrap/ui-bootstrap.min
//= require angular-filter/dist/angular-filter.min
//= require angular-route/angular-route.min
//= require angular-cookie/angular-cookie.min
//= require angular-truncate/src/truncate
//= require moment/min/moment.min
//= require ng-token-auth/dist/ng-token-auth.min
//= require angular-toastr/dist/angular-toastr.min
//= require angular-toastr/dist/angular-toastr.tpls.min
//= require_tree .

angular.module('toptal', [
    // Angular modules
    'ngRoute', 'ng-token-auth',

    // Third party modules
    'ui.bootstrap', 'truncate', 'angular.filter', 'toastr',

    // App specific modules
    'api', 'login', 'account', 'admin', 'meals', 'navbar', 'smartTime'
  ]).

  config([
    '$routeProvider', '$authProvider', '$httpProvider', 'toastrConfig',
  function($routeProvider, $authProvider, $httpProvider, toastrConfig) {

    $authProvider.configure({
      apiUrl: '/api/v1'
    });

    $routeProvider.
      when('/', {
        templateUrl: '/assets/login/login.tpl.html',
        controller: 'LoginController'
      }).

      when('/meals', {
        templateUrl: '/assets/meals/index.tpl.html',
        controller: 'MealsController',
        resolve: {
          auth: ['$auth', function($auth) {
            return $auth.validateUser();
          }]
        }
      }).

      when('/account', {
        templateUrl: '/assets/account/users.tpl.html',
        controller: 'UsersController',
        resolve: {
          auth: requirePrivilege('account_manager')
        }
      }).

      when('/admin/users', {
        templateUrl: '/assets/admin/users.tpl.html',
        controller: 'AdminUsersController',
        resolve: {
          auth: requirePrivilege('admin')
        }
      }).

      when('/admin/meals', {
        templateUrl: '/assets/admin/meals.tpl.html',
        controller: 'AdminMealsController',
        resolve: {
          auth: requirePrivilege('admin')
        }
      }).

      otherwise({ redirectTo: '/meals' });

    function requirePrivilege(privilege) {
      return ['$auth', '$q', function($auth, $q) {
        var deferred = $q.defer();

        $auth.validateUser().then(function(user) {
          if (user[privilege]) {
            deferred.resolve(user);
          } else {
            deferred.reject();
          }
        }, deferred.reject);

        return deferred.promise;
      }];
    }

    toastrConfig.positionClass = 'toast-top-center';
    toastrConfig.closeButton = true;
    toastrConfig.allowHtml = true;

    function buildMessage(errors) {
      var html = '';
      errors.forEach(function(error) {
        html += '<p>'+ error + '</p>';
      });

      return html;
    }

    $httpProvider.interceptors.push(['$q', 'toastr', function($q, toastr) {
      return {
        responseError: function(response) {
          toastr.clear();

          switch (response.status) {
            case 401:
            case 422:
              toastr.error(buildMessage(response.data.errors));
              break;

            case 403:
              toastr.error(buildMessage(response.data.errors.full_messages))
              break;
            default:
              toastr.error('Something went wrong');
          }

          return $q.reject(response);
        }
      };
    }]);
  }]).

  run(['$rootScope', '$location', function($rootScope, $location) {
    $rootScope.$on('$routeChangeError', function(event, current, previous, eventObj) {
      $location.path('/');
    });
  }]);
