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

  // Aquí tengo que modificar folio (ese debe estar anclado al tipo de factura)
  $('#store_name').bind('change', function() {
    store_values = ['#store_rfc', '#tax_regime', '#series', '#folio', '#zipcode'];
    store_values.forEach(function(field) {
      $(field).children().each(function () {
        if ($(this).val().toString() == $('#store_name').val()) {
          $(this).attr("selected","selected");
        }
      });
    });
  });

  // Todavía está pendiente que no tenga que dar tantos tabs
  function putTaxes(prod_id) {
    quant = parseFloat($('#quantity_' + prod_id).val());
    price = parseFloat($('#unit_value_hidden_' + prod_id).val());
    $('#subtotal_' + prod_id).val(price);
    $('#unit_value_hidden_' + prod_id).val(price);
    if ($('#discount_' + prod_id).val() == '') {
      discountRow = 0;
    } else {
      discountRow = parseFloat($('#discount_' + prod_id).val());
    }
    base = (parseFloat(price) - parseFloat(discountRow)) * quant;
    taxValue = parseFloat(
      (base * 0.16).toFixed(2)
    );
    $('#taxes_' + prod_id).val(taxValue);
  }

  function putTotals() {
    subtotVal = 0;
    taxVal = 0;
    discVal = 0;
    $('input[id^="discount_"]').each(function() {
      discountSum = 0;
      if ($(this).attr('id') != "discount_") {
        if ($(this).val() == '') {
          discVal += 0;
        } else {
          discVal += parseFloat(parseFloat($(this).val()).toFixed(2));
        }
        discountSum += parseFloat(discVal);
        $('#bill_discount').val(discountSum);
      }
    });
    $('input[id^="subtotal_"]').each(function() {
      subtotalSum = 0;
      if ($(this).attr('id') != "subtotal_") {
        if ($(this).val() == '') {
          subtotVal += 0;
        } else {
          subtotVal += parseFloat(parseFloat($(this).val()).toFixed(2));
        }
        subtotalSum += parseFloat(subtotVal);
        $('#bill_subtotal').val(subtotalSum.toFixed(2));
      }
    });
    $('input[id^="taxes_"]').each(function() {
      if ($(this).attr('id') != "taxes_") {
        taxesSum = 0;
        if ($(this).val() == '') {
          taxVal += 0;
        } else {
          taxVal += parseFloat(parseFloat($(this).val()).toFixed(2));
        }
        taxesSum += parseFloat(taxVal);
        $('#bill_taxes').val(taxesSum.toFixed(2));
      }
    });
    totalSum = 0;
    totalSum += parseFloat(parseFloat($('#bill_subtotal').val()).toFixed(2));
    totalSum -= parseFloat(parseFloat($('#bill_discount').val()).toFixed(2));
    totalSum += parseFloat(parseFloat($('#bill_taxes').val()).toFixed(2));
    $('#bill_total').val(totalSum.toFixed(2));
  }

  $(".close-icon a").click(function(){
    debugger
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
          parent = $(this).parent().parent();
          prod_id = suggestion.data;
          var rowSelects = ['#product_id_', '#sat_key_', '#unique_code_', '#sat_unit_key_', '#sat_unit_description_', '#product_description_select_', '#unit_value_'];
          var allRows = ['#product_id_', '#sat_key_', '#unique_code_', '#quantity_', '#product_description_', '#sat_unit_key_', '#sat_unit_description_', '#product_description_select_', '#unit_value_', '#discount_', '#taxes_', '#subtotal_', '#unit_value_hidden_'];
          allRows.forEach(function(field) {
            if ($(field).attr('id') == 'discount_') {
              $(field).val(0);
            }
            $(field).attr('id', field.replace("#", "") + prod_id);
          });
          rowSelects.forEach(function(rowSelect) {
            $(rowSelect + prod_id).children().each(function () {
              if ($(this).val().toString() == prod_id) {
                $(this).attr("selected","selected");
                if ($(this).parent().attr('id') == 'unit_value_' + prod_id) {
                  quantity = $('#quantity_' + prod_id);
                  quantity.val(1);
                  q = parseInt(
                    quantity.val()
                  );

                  price = parseFloat($('#unit_value_' + prod_id).text());
                  $('#subtotal_' + prod_id).val(price);
                  $('#unit_value_hidden_' + prod_id).val(price);
                  if ($('#discount_' + prod_id).val() == '') {
                    discountRow = 0;
                  } else {
                    discountRow = parseFloat($('#discount_' + prod_id).val());
                  }
                  taxValue = parseFloat(
                    (((price * q) - discountRow) * 0.16).toFixed(2)
                  );
                  $('#taxes_' + prod_id).val(taxValue);
                  putTotals();

                  $('.quantity').blur(function() {
                    id = parseInt($(this).attr('id').replace("quantity_",""));
                    newQuantity = parseFloat($(this).val());
                    thisPrice = parseFloat($('#unit_value_hidden_' + id).val());
                    newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
                    newDiscount = parseFloat($('#discount_' + prod_id).val());
                    newTax = parseFloat(
                      ((newPrice - discountRow) * 0.16).toFixed(2) // aquí podría ser newDiscount
                    );
                    $('#subtotal_' + id).val(newPrice);
                    $('#taxes_' + id).val(newTax);
                    putTotals();
                  });
                  $('.discount').blur(function() {
                    discVal = 0;
                    $('input[id^="discount_"]').each(function() {
                      // Necesito anclar este valor al cambio de discount, no de quantity
                      discountSum = 0;
                      if ($(this).attr('id') != "discount_") {
                        id = $(this).attr('id').replace('discount_', '');
                        if ($(this).val() == '') {
                          discVal += 0;
                        } else {
                          discVal += parseFloat(parseFloat($(this).val()).toFixed(2));
                        }

                        // Revisar que lo calcule de una sola vez
                        newQuantity = parseFloat($('#quantity_').val());
                        thisPrice = parseFloat($('#unit_value_hidden_' + id).val());
                        newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
                        newDiscount = parseFloat($('#discount_' + prod_id).val());
                        $('#subtotal_' + id).val(newPrice);

                        discountSum += parseFloat(discVal);
                        putTaxes(id);
                        $('#bill_discount').val(discountSum.toFixed(2));
                      }
                    });
                    putTotals();
                  });

                } else if ($(this).parent().attr('id') == 'product_description_select_' + prod_id) {
                  desc = $(this).text();
                  $('#product_description_' + prod_id).val(desc);
                }
              }
            });
          });
        }
      });
    });
    rowCount ++;
  });

});
