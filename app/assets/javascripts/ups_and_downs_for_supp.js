$(document).ready(function() {

  action = $("#action").html();
  newRows = $(".newRow");

  $('#checkPercent').change(function(){
    calculateSubtotal();
  });

  $('#supplier_taxes_rate').keyup(function(){
    calculateSubtotal();
  });

  $('#supplier_subtotal').keyup(function(){
    calculateSubtotal();
  });

  function rowTotal(idRow){
    quantity = parseInt($("#quantity_" + idRow).val());
    if (isNaN(quantity)) {
      quantity = 0;
    }
  }

  $('input#supplier_total_amount').on('keyup', function(){
    calculateSubtotal();
  });

  $('input#supplier_discount').on('keyup', function(){
    calculateSubtotal();
  });

  var calculateSubtotal = function(){
    var total = $('input#supplier_total_amount').val().replace(/,/,'');

    if (isNaN(parseFloat(total))) {
      total = 0;
    } else {
      total = parseFloat(total);
    }

    var taxesRate = ((100 +  parseFloat($('input#supplier_taxes_rate').val()) ) / 100);

    if (!$('#checkPercent').is(':checked')){
      taxesRate = parseFloat($('input#supplier_taxes_rate').val());
      $('#supplier_subtotal').val((total - taxesRate).toFixed(2));
    } else {
      $('#supplier_subtotal').val((total / taxesRate).toFixed(2));
    }

    $('#supplier_subtotal').maskMoney();

    suppDiscount = parseFloat($('#supplier_discount').val());

    if (isNaN(parseFloat(suppDiscount))) {
      suppDiscount = 0;
    } else {
      suppDiscount = parseFloat(suppDiscount);
    }

    $('#supplier_subtotal_with_discount').val(
      (suppDiscount + parseFloat($('#supplier_subtotal').val())).toFixed(2)
    );

  };

    $.ajax({
      url: '/api/get_all_suppliers_for_corporate',
    })
    .done(function(response){
      $('#suppliersAutocomplete').autocomplete({
        lookup: response.suggestions,
        onSelect: function (suggestion) {

          $('.toShowOnSelect').removeClass("hidden");

          $("#supplierName").val(
            suggestion.value
          );

          $("#credit_days").val(
            suggestion.days
          );

          $("#supplierId").val(
            suggestion.data
          );

          $('#suppliersAutocomplete').val('');
        }
      });
    });

    if (action == 'new') {
      $('input#supplier_taxes_rate').val(
        16.0
      );

      $("#supplier_total_amount").val(
        0.0
      );
    }

});
