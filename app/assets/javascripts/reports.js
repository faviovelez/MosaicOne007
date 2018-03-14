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
