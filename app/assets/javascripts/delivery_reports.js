$(document).ready(function(){

  $("#options").bind('change', function() {
    var options = $(this).val();
    if (options == 'Seleccionar día') {
      $(".group_fields").addClass("hidden");
      $("#date").removeClass("hidden");
    } else if (options == 'Mes actual') {
      $(".group_fields").addClass("hidden");
      $("#date").addClass("hidden");
    } else {
      $(".group_fields").removeClass("hidden");
      $("#date").addClass("hidden");
    }
  });

  $('#companies').select2({
     placeholder: 'Mensajerías',
     language: "es"
  });

});
