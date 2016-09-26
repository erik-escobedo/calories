(function() {
  angular.module('admin').
    controller('AdminUsersController', [
      '$scope', 'API', '$uibModal', 'auth',
    function($scope, API, $uibModal, auth) {

      $scope.users = [];

      function getUsers() {
        API.get('admin/users').then(function(response) {
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
          templateUrl: 'assets/admin/user_form.tpl.html',
          controller: 'AdminUsersFormController',
          resolve: { user: user }
        });

        modal.result.then(getUsers);
      };

      $scope.delete = function(user) {
        API.delete('admin/users', user.id).then(getUsers);
      };
    }]);
})();
