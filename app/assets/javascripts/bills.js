$(document).ready(function() {


  $('.select2-tickets').select2({
     placeholder: 'Tickets a facturar',
     language: "es"
  });

  $('.select2-prospect').select2({
     placeholder: 'Cliente de la factura',
     language: "es",
     maximumSelectionLength: 1
  });

  $('.select2-cfdi').select2({
     placeholder: 'Uso para la factura',
     language: "es",
     maximumSelectionLength: 1
  });

  $('.select2-cfdi_type').select2({
     placeholder: 'Tipo de factura',
     language: "es",
     maximumSelectionLength: 1
  });

  $("#cfdi_type_prospect").click(function () {
    $(".select_prospect").removeClass('hidden');
  });

  $("#cfdi_type_global").click(function () {
    $(".select_prospect").addClass('hidden');
  });

});
