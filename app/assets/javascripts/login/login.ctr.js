(function() {
  angular.module('login', []).
    controller('LoginController', [
      '$scope', '$auth', '$location',
    function($scope, $auth, $location) {

      var redirect = function(response) { $location.path('/meals'); };

      $auth.validateUser().then(redirect);

      $scope.form = {};

      $scope.switch = function() {
        $scope.registration = !$scope.registration;
      };

      $scope.submit = function() {
        if ($scope.registration) {
          $auth.submitRegistration($scope.form).then(redirect);
        } else {
          $auth.submitLogin($scope.form).then(redirect);
        }
      };
    }]);
})();
