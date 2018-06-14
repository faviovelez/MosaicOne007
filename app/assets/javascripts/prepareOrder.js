$(document).ready(function(){

  $('[id^="redAddOn_"]').click(function (event) {
    event.preventDefault();
    wrapperId = $(this).attr("id").replace("redAddOn_","");
    $("#myWrapper_" + wrapperId).addClass("hidden");
    $("#iconLink_" + wrapperId).removeClass("hidden")
  });

  $('[id^="iconLink_"]').click(function () {
    iconId = $(this).attr("id").replace("iconLink_","");
    $("#iconLink_" + iconId).addClass("hidden")
    $("#myWrapper_" + iconId).removeClass("hidden");
  });

});
