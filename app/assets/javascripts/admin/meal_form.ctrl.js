(function() {
  angular.module('admin').
    controller('AdminMealsFormController', [
      '$scope', '$uibModalInstance', 'API', 'dateFilter', 'smartTime', 'meal',
    function($scope, $uibModalInstance, API, dateFilter, smartTime, meal) {

      function initMeal(meal) {
        $scope.meal = angular.copy(meal) || {
          taken_at: new Date(),
          calories: 100
        };
        $scope.meal.date = new Date($scope.meal.taken_at);
        $scope.meal.time = dateFilter($scope.meal.taken_at, 'shortTime');

        API.get('admin/users').then(function(response) {
          $scope.users = response.data;

          $scope.selectedUser = $scope.users.filter(function(user) {
            return user.id == $scope.meal.user_id;
          })[0] || $scope.users[0];
        });
      }
      initMeal(meal);

      $scope.parseTime = function() {
        $scope.meal.time = smartTime($scope.meal.time);
      };

      $scope.submit = function() {
        var takenAt = smartTime.toDate($scope.meal.date, $scope.meal.time);
        var params = {
          meal: {
            user_id: $scope.selectedUser.id,
            calories: $scope.meal.calories,
            description: $scope.meal.description,
            // Remove timezone to make time neutral
            taken_at: moment(takenAt).format().replace(/-\d\d:\d\d$/, '')
          }
        };

        var promise;
        if ($scope.meal.id) {
          promise = API.put('admin/meals', $scope.meal.id, params);
        } else {
          promise = API.post('admin/meals', params);
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
