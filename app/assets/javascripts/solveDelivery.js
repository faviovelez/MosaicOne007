$(document).ready(function(){

  $(".group-solved").addClass("hidden");

  $('#order_solved').bind('change', function() {
    if ($(this).is(":checked")) {
      $(".group-solved").addClass("hidden");
    } else {
      $(".group-solved").removeClass("hidden");
    }
  });

});
