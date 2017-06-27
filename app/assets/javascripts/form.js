var counter = 0;
$(".requests.new").ready(function() {
  $("#request_product_type").bind('change', function() {
    var productType = $(this).val();

    if (productType == 'otro') {
      $(".otro").removeClass('hidden');
      $(".measures").removeClass('hidden');
      if (counter == 0) {
        $(".medidas").append('<option value="1" selected="selected" class="new">medidas externas</option>');
        counter +=1;
      };
      $(".caja").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".exhibidor").addClass('hidden');

    } else if (productType == 'caja') {
      $(".caja").removeClass('hidden');
      $(".measures").removeClass('hidden');
      if (counter == 0) {
        $(".medidas").append('<option value="1" selected="selected" class="new">medidas externas</option>');
        counter +=1;
      };
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".exhibidor").addClass('hidden');

    } else if (productType == 'bolsa') {
      $(".bolsa").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');

    } else if (productType == 'exhibidor') {
      $(".exhibidor").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');

    } else if (productType == 'seleccione') {
      $(".otro").addClass('hidden');
      $(".measures").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $("#outer").addClass('hidden');
      $(".measures").addClass('hidden');
    };

  });

  $(".medidas").bind('change', function() {
    var measures = $(".medidas").val();

    if (measures == 0) {
      $("#outer").addClass('hidden');
      $("#inner").addClass('hidden');
    } else if (measures == 1) {
      $("#outer").removeClass('hidden');
      $("#inner").addClass('hidden');
    } else if (measures == 2) {
      $("#inner").removeClass('hidden');
      $("#outer").addClass('hidden');
    } else if (measures == 3) {
      $("#outer").removeClass('hidden');
      $("#inner").removeClass('hidden');
    };
  });
});
