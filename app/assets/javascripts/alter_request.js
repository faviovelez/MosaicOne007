$(document).ready(function() {
  $("#request_what_measures").bind('change', function() {
    var measures = $("#request_what_measures").val();

    if (measures == '') {
      $("#outer").addClass('hidden');
      $("#inner").addClass('hidden');
    } else if (measures == 1) {
      $("#outer").removeClass('hidden');
      $("#inner").addClass('hidden');
    } else if (measures == 2) {
      $("#inner").removeClass('hidden');
      $("#outer").addClass('hidden');
    };
  });
});
