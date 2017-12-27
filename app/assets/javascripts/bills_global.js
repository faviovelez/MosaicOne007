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

  function putTaxes(rowCount) {
    quant = parseFloat($('#quantity_' + rowCount).val());
    price = parseFloat($('#unit_value_' + rowCount).val());
    $('#subtotal_' + rowCount).val(price);
    $('#unit_value_' + rowCount).val(price);
    if ($('#discount_' + rowCount).val() == '') {
      discountRow = 0;
    } else {
      discountRow = parseFloat($('#discount_' + rowCount).val());
    }
    base = (parseFloat(price) - parseFloat(discountRow)) * quant;
    taxValue = parseFloat(
      (base * 0.16).toFixed(2)
    );
    $('#taxes_' + rowCount).val(taxValue);
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

  // Este no sirve
  $(".close-icon a").click(function(){
    debugger
  });

  var newRows = $(".newRow");
  var rowCount = 1;
  $("#addNewRow").click(function(){
    var clone = newRows.clone();
    clone.attr('id', 'row' + rowCount);
    $("#fields_for_products").prepend(clone);
    var rowSelects = ['#tickets_', '#sat_key_', '#quantity_', '#sat_unit_key_', '#sat_unit_description_', '#unit_value_', '#discount_', '#taxes_', '#subtotal_',];
    var allRows = ['#tickets_', '#sat_key_', '#quantity_', '#sat_unit_key_', '#sat_unit_description_', '#unit_value_', '#discount_', '#taxes_', '#subtotal_',];
    allRows.forEach(function(field) {
      if ($(field).attr('id') == 'discount_' || $(field).attr('id') == 'unit_value_' || $(field).attr('id') == 'taxes_' || $(field).attr('id') == 'subtotal_') {
        $(field).val(0);
      }
      $(field).attr('id', field.replace("#", "") + rowCount);
    });
    $('.unit_value').blur(function() {
      id = parseInt($(this).attr('id').replace("unit_value_",""));
      thisPrice = parseFloat($(this).val());
      newQuantity = parseInt($('#quantity_' + id).val());
      newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
      newDiscount = parseFloat($('#discount_' + rowCount).val());
      newTax = parseFloat(
        ((newPrice - newDiscount) * 0.16).toFixed(2)
      );
      $('#subtotal_' + id).val(newPrice);
      $('#taxes_' + id).val(newTax);
      putTotals();
    });
    $('.discount').blur(function() {
      discVal = 0;
      $('input[id^="discount_"]').each(function() {
        id = $(this).attr('id').replace('discount_', '');
        // Necesito anclar este valor al cambio de discount, no de quantity
        discountSum = 0;
        if ($(this).attr('id') != "discount_") {
          if ($(this).val() == '') {
            discVal += 0;
          } else {
            discVal += parseFloat(parseFloat($(this).val()).toFixed(2));
          }

          // Revisar que lo calcule de una sola vez
          newQuantity = parseFloat($('#quantity_').val());
          thisPrice = parseFloat($('#unit_value_hidden_' + id).val());
          newPrice = parseFloat((newQuantity * thisPrice).toFixed(2));
          newDiscount = parseFloat($('#discount_' + id).val());
          $('#subtotal_' + id).val(newPrice);

          discountSum += parseFloat(discVal);
          putTaxes(id);
          $('#bill_discount').val(discountSum.toFixed(2));
        }
      });
      putTotals();
    });

  });


});
