(function() {
  angular.module('meals').
    controller('MealsFormController', [
      '$scope', '$uibModalInstance', 'API', 'dateFilter', 'smartTime', 'meal',
    function($scope, $uibModalInstance, API, dateFilter, smartTime, meal) {

      function initMeal(meal) {
        $scope.meal = angular.copy(meal) || {
          taken_at: new Date(),
          calories: 100
        };
        $scope.meal.date = new Date($scope.meal.taken_at);
        $scope.meal.time = dateFilter($scope.meal.taken_at, 'shortTime');
      }
      initMeal(meal);

      $scope.parseTime = function() {
        $scope.meal.time = smartTime($scope.meal.time);
      };

      $scope.submit = function() {
        var takenAt = smartTime.toDate($scope.meal.date, $scope.meal.time);
        var params = {
          meal: {
            calories: $scope.meal.calories,
            description: $scope.meal.description,
            // Remove timezone to make time neutral
            taken_at: moment(takenAt).format().replace(/-\d\d:\d\d$/, '')
          }
        };

        var promise;
        if ($scope.meal.id) {
          promise = API.put('meals', $scope.meal.id, params);
        } else {
          promise = API.post('meals', params);
        }

        promise.then(function(response) {
          $uibModalInstance.close(response.data);
        });
      };

      $scope.cancel = function() {
        $uibModalInstance.dismiss('cancel');
      };
    }]);
})();
