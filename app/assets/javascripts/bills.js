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
    if ($('#discount_' + prod_id).val() == '') {
      discountRow = 0;
    } else {
      discountRow = parseFloat($('#discount_' + prod_id).val());
    }
    subt = parseFloat((price * quant).toFixed(2));
    base = subt - discountRow;
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
        $('#bill_discount').val(discountSum.toFixed(2));
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

    $.ajax({
      url: '/api/get_prospects_for_store',
    })
    .done(function(response){
      $('.select-prospect').autocomplete({
        lookup: response.suggestions,
        onSelect: function (suggestion) {
          var prospect_id = suggestion.data;
          $.ajax({
            url: '/api/select_prospects_info',
            data: {prospect_id: prospect_id}
          })
          .done(function(response){
            $('#prospect_rfc').val(response.prospect);
          })
        }
      });
    });

  setTimeout(function(){
    $(".close-icon").on('click', function() {
      var row = $(this).parent().parent();
      thisId = $(this).attr('id').replace('close_icon_', '');
      var discDel = parseFloat($('#discount_' + thisId).val());
      var taxDel = parseFloat($('#taxes_' + thisId).val());
      var subtDel = parseFloat($('#subtotal_' + thisId).val());
      var totalDel = subtDel - discDel + taxDel;
      var actSubtotal = parseFloat($('#bill_subtotal').val());
      var actDiscount = parseFloat($('#bill_discount').val());
      var actTaxes = parseFloat($('#bill_taxes').val());
      var actTotal = parseFloat($('#bill_total').val());
      $('#bill_subtotal').val((parseFloat(actSubtotal - subtDel)).toFixed(2));
      $('#bill_taxes').val((parseFloat(actTaxes - taxDel)).toFixed(2));
      $('#bill_discount').val((parseFloat(actDiscount - discDel)).toFixed(2));
      $('#bill_total').val((parseFloat(actTotal - totalDel)).toFixed(2));
      row.remove();
    });
  }, 2500);

  function getNewTotals() {
    setTimeout(function(){
      $('#bill_subtotal').val(actSubtotal - subtDel);
      $('#bill_taxes').val(actTaxes - taxDel);
      $('#bill_discount').val(actDiscount - discDel);
      $('#bill_total').val((actTotal - totalDel).toFixed(2));
      row.remove();
    }, 500);
  }

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
          allRows = ['#product_id_', '#sat_key_', '#unique_code_', '#quantity_', '#product_description_', '#sat_unit_key_', '#sat_unit_description_', '#product_description_select_', '#unit_value_', '#discount_', '#taxes_', '#subtotal_', '#unit_value_hidden_', '#close_icon_'];
          rowSelects = ['#product_id_', '#sat_key_', '#unique_code_', '#sat_unit_key_', '#sat_unit_description_', '#product_description_select_', '#unit_value_'];
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
                  if (quantity.val() == '') {
                    quantity.val(1);
                  }
                  q = parseInt(
                    quantity.val()
                  );

                  price = parseFloat($('#unit_value_' + prod_id).find(":selected").text());
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
                  setTimeout(function(){
                    $(".close-icon").on('click', function() {
                      row = $(this).parent().parent();
                      thisId = $(this).attr('id').replace('close_icon_', '');
                      discDel = parseFloat($('#discount_' + thisId).val());
                      taxDel = parseFloat($('#taxes_' + thisId).val());
                      subtDel = parseFloat($('#subtotal_' + thisId).val());
                      totalDel = subtDel - discDel + taxDel;
                      actSubtotal = parseFloat($('#bill_subtotal').val());
                      actDiscount = parseFloat($('#bill_discount').val());
                      actTaxes = parseFloat($('#bill_taxes').val());
                      actTotal = parseFloat($('#bill_total').val());
                      getNewTotals();
                    });
                  }, 2500);
                  $('.quantity').blur(function() {
                    id = parseInt($(this).attr('id').replace("quantity_",""));
                    newQuantity = parseFloat($(this).val());
                    thisPrice = parseFloat($('#unit_value_hidden_' + id).val());
                    newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
                    newDiscount = parseFloat($('#discount_' + id).val());
                    newTax = parseFloat(
                      ((newPrice - discountRow) * 0.16).toFixed(2) // aquí podría ser newDiscount
                    );
                    $('#subtotal_' + id).val(newPrice.toFixed(2));
                    $('#taxes_' + id).val(newTax.toFixed(2));
                    putTotals();
                  });
                  $('.unit_value_hidden').blur(function() {
                    id = $(this).attr('id').replace('unit_value_hidden_', '');
                    quantityNewValue = parseFloat($('#quantity_' + id).val());
                    priceNewValue = parseFloat($(this).val());
                    subtotalNewValue = parseFloat(quantityNewValue * priceNewValue);
                    myNewDiscount = parseFloat($('#discount_' + id).val());
                    taxNewValue = parseFloat((subtotalNewValue - myNewDiscount) * 0.16);
                    $('#subtotal_' + id).val((parseFloat(subtotalNewValue)).toFixed(2));
                    $('#taxes_' + id).val((parseFloat(taxNewValue)).toFixed(2));
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
                        newQuantity = parseFloat($('#quantity_' + id).val());
                        thisPrice = parseFloat($('#unit_value_hidden_' + id).val());
                        newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
                        newDiscount = parseFloat($('#discount_' + id).val());
                        $('#subtotal_' + id).val(newPrice.toFixed(2));

                        discountSum += parseFloat(discVal.toFixed(2));
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
