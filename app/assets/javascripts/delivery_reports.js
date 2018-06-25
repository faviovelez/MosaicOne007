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

  $('#store_list').select2({
     placeholder: 'Tiendas',
     language: "es"
  });

  $("#store_options").bind('change', function() {
    var storeOptions = $(this).val();
    if (storeOptions == 'Seleccionar tiendas') {
      $(".select2.select2-container").addClass("width-200");
      $('.store-list').removeClass('hidden');
    } else {
      $('.store-list').addClass('hidden');
    }
  });

});
