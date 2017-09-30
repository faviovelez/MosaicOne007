$(document).ready(function() {


  $('.select2-field').select2({
     placeholder: 'seleccione productos',
     language: "es",
  });

  $('#discount_rule_prospect_list').select2({
     placeholder: 'seleccione clientes',
     language: "es",
  });

  $('#store_zip_code').select2({
     placeholder: 'seleccione clientes',
     language: "es",
  });

  $('.select2-field-limit1').select2({
     placeholder: 'seleccione productos',
     language: "es",
     maximumSelectionLength: 1,
  });

  $(".who").bind('change', function() {
    var whoType = $(this).val();

    if (whoType == 'seleccionar de la lista') {
      $(".prospect-list").removeClass('hidden');
    } else {
      $(".prospect-list").addClass('hidden');
    };

  });

/* Este método esconde o muestra las opciones, dependiendo de la elección */
  $(".which").bind('change', function() {
    var whichType = $(this).val();

    if (whichType == 'seleccionar de la lista') {
      $(".product-list").removeClass('hidden');
      $(".product-line").addClass('hidden');
      $(".product-material").addClass('hidden');

    } else if (whichType == 'seleccionar líneas de producto') {
      $(".product-line").removeClass('hidden');
      $(".product-list").addClass('hidden');
      $(".product-material").addClass('hidden');

    } else if (whichType == 'seleccionar productos por material') {
      $(".product-material").removeClass('hidden');
      $(".product-list").addClass('hidden');
      $(".product-line").addClass('hidden');

    } else {
      $(".product-list").addClass('hidden');
      $(".product-line").addClass('hidden');
      $(".product-material").addClass('hidden');
    };

  });

  $("#gift").bind('change', function() {
    if ($('#gift').is(':checked')) {
      $(".product-gift").removeClass('hidden');
    } else {
      $(".product-gift").addClass('hidden');
    };
  });

});
