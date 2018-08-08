$(document).ready(function(){

  $('#store_list').select2({
     placeholder: 'Tiendas',
     language: "es"
  });

  $('#month_and_year').select2({
     placeholder: 'Mes y año',
     language: "es",
     maximumSelectionLength: 1
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
