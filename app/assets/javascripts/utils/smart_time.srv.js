(function() {
  angular.module('smartTime', []).
    service('smartTime', function() {
      function f(n) {
        return ('' + (n + 100)).slice(1, 3);
      }

      function parse(string) {
        var time = {
          hours:    parseInt((string.match(/(\d{1,2})[\.:]?/) || [])[1]) || 0,
          minutes:  parseInt((string.match(/[\.:](\d{1,2})/)|| [])[1] || 0),
          meridiem: (string.match(/([ap])m?$/i) || [])[1]
        };

        if (!time.meridiem) {
          time.meridiem = time.hours < 7 ? 'p' : 'a';
        }

        if (time.hours > 12) {
          time.hours %= 12;
          time.meridiem = 'p';
        }

        return time;
      }

      function smartTime(string) {
        var time = parse(string);

        return time.hours + ':' + f(time.minutes) + ' ' + time.meridiem + 'm';
      }

      smartTime.toDate = function(date, timeString) {
        var time = parse(timeString);
        if (time.meridiem.toLowerCase() == 'p' && time.hours < 12) {
          date.setHours(time.hours + 12);
        } else {
          date.setHours(time.hours);
        }
        date.setMinutes(time.minutes);

        return date;
      };

      return smartTime;
    });
})();
