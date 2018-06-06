$(document).ready(function() {
  $('[id^=payments_]').on('keyup', function(){
    var id = $(this).attr('id').replace('payments_', '');
    var limitValue = parseFloat($("#balance_" + id).html().replace(/ /g, '').replace(/,/g, '').replace('$',''));
    var tryValue = parseInt($(this).val().replace(/ /g, ''));
    if ( tryValue > limitValue ){
      $(this).val(limitValue);
    }

    var sumPayments = 0;

    $('[id^=payments_]').each(function() {
      sumPayments += Number($(this).val());
    });

    $("#total_payment").val(sumPayments.toFixed(2))
  });
});
