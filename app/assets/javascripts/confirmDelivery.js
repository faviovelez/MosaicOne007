$(document).ready(function(){

  $('[id^="redLink_"]').click(function () {
    redIconId = $(this).attr("id").replace("redLink_","");
    $("#redLink_" + redIconId).addClass("hidden");
    $("#redWrapper_" + redIconId).removeClass("hidden");
    $("#greenLink_" + redIconId).addClass("hidden");
    $("#for-hide_" + redIconId).addClass("alter-hidden");
    $("#for-hide_" + redIconId).removeClass("alter-show");
  });

  $('[id^="greenLink_"]').click(function () {
    greenIconId = $(this).attr("id").replace("greenLink_","");
    $("#greenLink_" + greenIconId).addClass("hidden");
    $("#greenWrapper_" + greenIconId).removeClass("hidden");
    $("#redLink_" + greenIconId).addClass("hidden");
    $("#for-hide_" + greenIconId).addClass("alter-hidden");
    $("#for-hide_" + greenIconId).removeClass("alter-show");
  });

  $('[id^="redAddOn_"]').click(function (event) {
    event.preventDefault();
    var redWrapperId = $(this).attr("id").replace("redWrapper_","");
    $("#redWrapper_" + redIconId).addClass("hidden");
    $("#redLink_" + redIconId).removeClass("hidden")
    $("#greenLink_" + redIconId).removeClass("hidden");
    $("#for-hide_" + redIconId).removeClass("alter-hidden");
    $("#for-hide_" + redIconId).addClass("alter-show");
  });

  $('[id^="greenAddOn_"]').click(function (event) {
    event.preventDefault();
    var greenWrapperId = $(this).attr("id").replace("greenWrapper_","");
    $("#greenWrapper_" + greenIconId).addClass("hidden");
    $("#greenLink_" + greenIconId).removeClass("hidden");
    $("#redLink_" + greenIconId).removeClass("hidden");
    $("#for-hide_" + greenIconId).removeClass("alter-hidden");
    $("#for-hide_" + greenIconId).addClass("alter-show");
  });

  $('.for-hide-checkbox').bind('change', function() {
    var hide_for = $(this);
    var hideForId = $(this).attr("id").replace("product_requests[","").replace("]","");
    if (hide_for.is(":checked")) {
      $("#redLink_" + hideForId).addClass("hidden");
      $("#greenLink_" + hideForId).addClass("hidden");
      $(".second-check_" + hideForId).addClass("hidden");
      $(".second-check_" + hideForId).prop( "checked", false );
    } else {
      $("#redLink_" + hideForId).removeClass("hidden");
      $("#greenLink_" + hideForId).removeClass("hidden");
      $(".second-check_" + hideForId).prop( "checked", true );
    }
  });

  $('#order_complete').bind('change', function() {
    if ($(this).is(":checked")) {
      $(".all-hide").addClass("hidden");
    } else {
      $(".all-hide").removeClass("hidden");
    }
  });


});
