$(document).ready(function() {

  $('.select2-prospect-form').select2({
     placeholder: 'Cliente',
     language: "es",
     maximumSelectionLength: 1,
     width: '100%'
  });

  $('.select2-store-form').select2({
     placeholder: 'Empresa',
     language: "es",
     maximumSelectionLength: 1,
     width: '100%'
  });

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

  $('.select2-product').select2({
     placeholder: 'Producto',
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

  $('#prospect_name').bind('change', function() {
    $('#prospect_rfc').children().each(function() {
      if ($(this).val().toString() == $('#prospect_name').val()) {
        $(this).attr("selected","selected");
      }
    });
  });

  $('#store_name').bind('change', function() {
    store_values = ['#store_rfc', '#tax_regime', '#series', '#folio', '#zipcode'];
    $(store_values).children().each(function() {
      if ($(this).val().toString() == $('#store_name').val()) {
        $(this).attr("selected","selected");
      }
    });
  });

  var newRows = $(".newRow");
  var rowCount = 1;
  $("#addNewRow").click(function(){
    var clone = newRows.clone();
    clone.attr('id', 'row' + rowCount);
    $("#fields_for_products").prepend(clone);
    $.ajax({
      url: '/api/get_all_products_for_bill',
    })
    .done(function(response){
      $('.select-product').autocomplete({
        lookup: response.suggestions,
        onSelect: function (suggestion) {
          var parent = $(this).parent().parent();
        }
      });
    });
    rowCount ++;
  });



});
