(function() {
  angular.module('navbar', []).
    directive('navbar', function() {
      return {
        templateUrl: '/assets/navbar/navbar.tpl.html',
        replace: true,

        controller: [
          '$scope', '$auth', '$location', '$rootScope',
        function($scope, $auth, $location, $rootScope) {
          var updateUser = function(user) {
            $auth.validateUser().then(function(user) {
              $scope.user = user;
            }, function() {
              $scope.user = null;
            });
          };
          updateUser();

          var events =[
            'auth:login-success',
            'auth:logout-success',
            'auth:registration-email-success'
          ];
          events.forEach(function(event) {
            $rootScope.$on(event, updateUser);
          });

          $scope.logout = function() {
            $auth.signOut().then(function(response) {
              $location.path('/');
            });
          };
        }]
      };
    });
})();
