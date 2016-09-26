(function() {
  angular.module('meals').
    controller('MealsController', [
      '$scope', '$uibModal', 'API', 'smartTime', 'dateFilter', 'auth',
    function($scope, $uibModal, API, smartTime, dateFilter, auth) {

      $scope.meals = [];
      $scope.dailyCalories = auth.daily_calories;

      $scope.filter = {
        date_from: new Date(),
        date_to:   new Date(),
        time_from: smartTime('0a'),
        time_to:   smartTime('11:59p')
      };

      function getMeals() {

        $scope.filter.time_from = smartTime($scope.filter.time_from);
        $scope.filter.time_to   = smartTime($scope.filter.time_to);
        var params = {
          date_from: dateFilter($scope.filter.date_from, 'M/d/yy'),
          date_to:   dateFilter($scope.filter.date_to, 'M/d/yy'),
          time_from: $scope.filter.time_from,
          time_to:   $scope.filter.time_to
        };

        API.get('meals', params).then(function(response) {
          $scope.meals = response.data;
          $scope.meals.forEach(function(meal) {
            // Make dates local
            meal.taken_at = new Date(moment(meal.taken_at.replace('Z', '')));
            meal.date = new Date(dateFilter(meal.taken_at, 'M/dd/yy'));
          });
        });
      }

      $scope.saveSettings = function() {
        if ($scope.savingSettings) return;

        $scope.savingSettings = true;
        API.put('settings', null, {
          settings: {
            daily_calories: $scope.dailyCalories
          }
        }).then(function() {
          $scope.savingSettings = false;
        });
      };

      $scope.parseDate = function(string) {
        return dateFilter(new Date(string));
      };

      $scope.openForm = function(meal) {
        var modal = $uibModal.open({
          templateUrl: 'assets/meals/form.tpl.html',
          controller: 'MealsFormController',
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
        API.delete('meals', meal.id).then(getMeals);
      };

      $scope.getMeals = getMeals;
      getMeals();
    }]);
})();
