(function() {
  angular.module('admin').
    controller('AdminMealsController', [
      '$scope', '$uibModal', 'API', 'smartTime', 'dateFilter', 'auth',
    function($scope, $uibModal, API, smartTime, dateFilter, auth) {

      $scope.meals = [];

      function getMeals() {
        API.get('admin/meals').then(function(response) {
          $scope.meals = response.data;
          $scope.meals.forEach(function(meal) {
            // Make dates local
            meal.taken_at = new Date(moment(meal.taken_at.replace('Z', '')));
            meal.date = new Date(dateFilter(meal.taken_at, 'M/dd/yy'));
          });
        });
      }

      $scope.openForm = function(meal) {
        var modal = $uibModal.open({
          templateUrl: 'assets/admin/meal_form.tpl.html',
          controller: 'AdminMealsFormController',
          resolve: { meal: meal }
        });

        modal.result.then(getMeals);
      };

      $scope.select = function(meal) {
        if (!meal.selected) {
          $scope.meals.forEach(function(m) { m.selected = false; });
          meal.selected = true;
        }
      };

      $scope.delete = function(meal) {
        API.delete('admin/meals', meal.id).then(getMeals);
      };

      $scope.getMeals = getMeals;
      getMeals();
    }]);
})();
