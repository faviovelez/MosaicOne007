$(document).ready(function() {

  $('[id^="discount_new_"]').each(function () {
    var discountId = $(this).attr("id").replace("discount_new_","");
    var discVal = (
      (parseFloat($('#initial_price_' + discountId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
      - parseFloat($('#unit_value_' + discountId).html().replace(/ /g, '').replace(/,/g, '').replace('$','')))
      /
      parseFloat($('#initial_price_' + discountId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
      * 100
    ).toFixed(1);
    $(this).val(discVal);

    var initialDiscount = parseFloat($('#initial_discount_' + discountId).html().replace(/ /g, '').replace('%',''));
    $('#final_discount_' + discountId).val(initialDiscount);

  });

  $('[id^="discount_new_"]').each(function () {
    $(this).val(0.0);
  });

  $('[id^="discount_new_"]').each(function () {
    $(this).inputmask("decimal");
  });

  $('[id^="unit_price_new_"]').each(function () {
    $(this).inputmask("decimal");
  });

  $('[id^="discount_new_"]').keyup(function(){
    var thisDiscId = $(this).attr("id").replace("discount_new_","");
    var unitPrice = parseFloat($('#initial_price_' + thisDiscId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
    var initialDiscount = parseFloat($('#initial_discount_' + thisDiscId).html().replace(/ /g, '').replace('%',''));
    var thisDiscount = parseFloat($(this).val());

    if (isNaN(thisDiscount) || thisDiscount == 0) {
      thisDiscount = 0;

      $('#new_discount_' + thisDiscId).html("35.0" + "%");
      $('#unit_value_' + thisDiscId).html("$" +
      (unitPrice * (1 - (initialDiscount / 100)))
      .toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
      )
    } else {
      if (thisDiscount > 100) {
        thisDiscount = 100;
        $(this).val(thisDiscount);
      }
      $('#unit_value_' + thisDiscId).html("$" +
      (unitPrice * (1 - (thisDiscount / 100)) * (1 - (initialDiscount / 100)))
      .toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
      )
      $('#new_final_price_' + thisDiscId).val(
        (unitPrice * (1 - (thisDiscount / 100)) * (1 - (initialDiscount / 100)))
        .toFixed(2)
      );
      $('#new_discount_' + thisDiscId).html( ((1 - (1 - (thisDiscount / 100)) * (1 - (initialDiscount / 100))) * 100).toFixed(1) + "%");
      $('#final_discount_' + thisDiscId).val(
         ((1 - (1 - (thisDiscount / 100)) * (1 - (initialDiscount / 100))) * 100).toFixed(1)
      );
    }
    calculateTotal(thisDiscId, 'discount');
  });

  $('[id^="unit_price_new_"]').keyup(function(){
    var unitId = $(this).attr("id").replace("unit_price_new_","");
    calculateTotal(unitId, 'unit price');
  });

  $('[id^="unit_price_new_"]').keyup(function(){
    var unitPriceId = $(this).attr("id").replace("unit_price_new_","");
  });

  $('[id^="price_new_"]').on('change', function(){
    var checkId = $(this).attr("id").replace("price_new_","");
    var thisCheckbox = $(this);
    var initialDiscount = parseFloat($('#initial_discount_' + checkId).html().replace(/ /g, '').replace('%',''));
    var secondaryUnitPrice = parseFloat($('#secondary_unit_price_' + checkId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''));
    $('#final_discount_' + checkId).val(initialDiscount);
    $('#new_final_price_' + checkId).val(
      secondaryUnitPrice
    );

    if (thisCheckbox.is(":checked")) {
      $('#unit_value_' + checkId).addClass('hidden');
      $('#unit_value_' + checkId).html("$" +
        parseFloat($('#secondary_unit_price_' + checkId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
      );
      $('#new_discount_' + checkId).html("35.0" + "%");
      $('#discount_new_' + checkId).val(0);
      $('#discount_new_' + checkId).addClass('hidden');
      $('#unit_price_new_' + checkId).val(
        parseFloat($('#secondary_unit_price_' + checkId).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
      );
      $('#unit_price_new_' + checkId).removeClass('hidden');
      calculateTotal(checkId, 'discount');
    } else {
      $('#unit_value_' + checkId).removeClass('hidden');
      $('#discount_new_' + checkId).removeClass('hidden');
      $('#unit_price_new_' + checkId).addClass('hidden');
      calculateTotal(checkId, 'discount');
    }
  });

  function calculateTotal(id, type){
    if (type == 'discount') {
      $("#total_new_" + id).val(
        ($('#unit_value_' + id).html().replace(/ /g, '').replace(/,/g, '').replace('$','')
        * $('#quantity_' + id).html().replace(/ /g, '').replace(/,/g, '')
        * 1.16).toFixed(2)
      )
    } else {
      var unitPrice = $('#unit_price_new_' + id).val().replace(/ /g, '').replace(/,/g, '').replace('$','');
      if (unitPrice < 0 || isNaN(unitPrice)) {
        unitPrice = 0;
        $('#unit_price_new_' + id).val(unitPrice);
      } else if (unitPrice > parseFloat($('#initial_price_' + id).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))) {
        unitPrice = parseFloat($('#initial_price_' + id).html().replace(/ /g, '').replace(/,/g, '').replace('$',''));
        $('#unit_price_new_' + id).val(unitPrice);
      }
      $("#total_new_" + id).val(
        (unitPrice * $('#quantity_' + id).html().replace(/ /g, '').replace(/,/g, '')
        * 1.16).toFixed(2)
      )
      discount = (
        (parseFloat($('#initial_price_' + id).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
        - unitPrice)
        /
        parseFloat($('#initial_price_' + id).html().replace(/ /g, '').replace(/,/g, '').replace('$',''))
        * 100
      ).toFixed(1);
      $('#new_discount_' + id).html(discount + "%");
      $('#final_discount_' + id).val(discount);
      $('#new_final_price_' + id).val(
        unitPrice
      );
    }
  }


});
