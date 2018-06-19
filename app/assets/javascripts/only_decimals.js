$(document).ready(function() {

  $("#amount").inputmask("decimal");

  $("#amount").on('keyup', function(){
    var maxValue = parseFloat($("#real_total").html());
    var thisValue = parseFloat($("#amount").val());
    if (thisValue > maxValue) {
      $("#amount").val(maxValue);
    }
  });

});
