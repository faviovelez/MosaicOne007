$(document).ready(function(){

  function validateDate(){
    if ($("#what_final_date").val() == 'Al día de hoy') {
      $("#date").addClass("hidden");
      $(".date-field-report").addClass("hidden");
    } else {
      $("#date").removeClass("hidden");
      $(".date-field-report").removeClass("hidden");
    }
  }

  $("#options").bind('change', function() {
    var options = $(this).val();
    if (options == 'Seleccionar día') {
      $(".group_fields").addClass("hidden");
      $(".extra-margin-top").removeClass("hidden");
    } else if (options == 'Mes actual') {
      $(".group_fields").addClass("hidden");
      $(".extra-margin-top").addClass("hidden");
    } else {
      $(".group_fields").removeClass("hidden");
      $(".extra-margin-top").addClass("hidden");
    }
  });

  $("#information").bind('change', function() {
    var informationSelect = $(this).val();
    if (informationSelect == 'Reporte de inventario') {
      $('#products option:contains("Todos los productos")').prop('selected', true);
      $(".movements-report").addClass("hidden");
      $(".inventory-report").removeClass("hidden");
      validateDate();
    } else {
      $('#products option:contains("Elegir producto")').prop('selected', true);
      $(".movements-report").removeClass("hidden");
      $(".inventory-report").addClass("hidden");
      validateDate();
    }
  });

  $("#what_final_date").bind('change', function() {
    var whatFinalDate = $(this).val();
    if (whatFinalDate == 'Al día de hoy') {
      $(".extra-margin-top").addClass("hidden");
      $("#date").addClass("hidden");
    } else {
      $(".extra-margin-top").removeClass("hidden");
      $("#date").removeClass("hidden");
    }
  });

  $("#what_final_date").bind('change', function() {
    var whatFinalDate = $(this).val();
    if (whatFinalDate == 'Al día de hoy') {
      $("#date").addClass("hidden");
    } else {
      $("#date").removeClass("hidden");
    }
  });

  $("#products").bind('change', function() {
    var products = $(this).val();
    if (products == 'Elegir producto') {
      $(".product-select-2").removeClass("hidden");
      $("input.select2-search__field").addClass("width-450")
    } else {
      $(".product-select-2").addClass("hidden");
    }
  });

  $('.select2-products').select2({
     placeholder: 'Seleccione un producto',
     language: "es"
  });


});
