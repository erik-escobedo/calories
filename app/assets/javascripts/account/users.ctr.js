(function() {
  angular.module('account').
    controller('UsersController', [
      '$scope', 'API', '$uibModal', 'auth',
    function($scope, API, $uibModal, auth) {

      $scope.users = [];

      function getUsers() {
        API.get('users').then(function(response) {
          $scope.users = response.data;
        });
      }
      getUsers();

      $scope.select = function(user) {
        if (!user.selected) {
          $scope.users.forEach(function(u) { u.selected = false; });
          user.selected = true;
        }
      };

      $scope.openForm = function(user) {
        var modal = $uibModal.open({
          templateUrl: 'assets/account/form.tpl.html',
          controller: 'UsersFormController',
          resolve: { user: user }
        });

        modal.result.then(getUsers);
      };

      $scope.delete = function(user) {
        API.delete('users', user.id).then(getUsers);
      };
    }]);
})();
