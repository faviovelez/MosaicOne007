var counter = 0;
$(".requests.new").ready(function() {

/* Este método esconde o muestra las opciones, dependiendo de la elección del tipo de producto, por ejepmlo: medidas externas, medidas de bolsa, medidas de exhibidor, etc. */
  $("#request_product_type").bind('change', function() {
    var productType = $(this).val();

    if (productType == 'otro') {
      $(".otro").removeClass('hidden');
      $(".measures").removeClass('hidden');
      if (counter == 0) {
        $(".medidas").append('<option value="1" selected="selected" class="new">medidas externas</option>');
        counter +=1;
        $("#outer").removeClass('hidden');
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
        $("#outer").removeClass('hidden');
      };
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
      $(".resistance.secondary.bolsa").addClass('hidden');
      $(".resistance.third.bolsa").addClass('hidden');

    } else if (productType == 'bolsa') {
      counter -=1;
      $(".bolsa").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $("#outer").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $(".resistance.main.caja").addClass('hidden');

    } else if (productType == 'exhibidor') {
      counter -=1;
      $(".exhibidor").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
      $("#outer").addClass('hidden');

    } else if (productType == 'seleccione') {
      counter -=1;
      $(".otro").addClass('hidden');
      $(".measures").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $("#outer").addClass('hidden');
      $(".measures").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
    };

  });

/* Este método esconde o muestra las opciones, dependiendo de la elección del tipo de medidas (internas o extenras) */
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

/* Este método esconde o muestra las resistencias, dependiendo de la elección del tipo de material elegido (primer material)*/
  $("#request_main_material").bind('change', function() {
    var material = $("#request_main_material").val();

    if (material == 'reverso gris' ||
      material == 'reverso blanco' ||
      material == 'caple' ||
      material == 'sulfatada' ||
      material == 'multicapa') {
      $(".main.plegadizo").removeClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'liner') {
      $(".main.liner").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'microcorrugado' ||
      material == 'single face' ||
      material == 'papel kraft' ||
      material == 'papel bond') {
      $(".main.otros").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'rígido') {
      $(".main.rigid").removeClass('hidden');
      $(".main.otros").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.liner").addClass('hidden');

    } else if (material == 'doble_corrugado') {
      $(".main.doble_corrugado").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'corrugado') {
      $(".main.corrugado").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');
    };
  });

/* Este método esconde o muestra las resistencias, dependiendo de la elección del tipo de material elegido (segundo material)*/
  $("#request_secondary_material").bind('change', function() {
    var material = $("#request_secondary_material").val();

    if (material == 'reverso gris' ||
      material == 'reverso blanco' ||
      material == 'caple' ||
      material == 'sulfatada' ||
      material == 'multicapa') {
      $(".secondary.plegadizo").removeClass('hidden');
      $(".secondary.liner").addClass('hidden');
      $(".secondary.corrugado").addClass('hidden');
      $(".secondary.doble_corrugado").addClass('hidden');
      $(".secondary.otros").addClass('hidden');

    } else if (material == 'liner') {
      $(".secondary.liner").removeClass('hidden');
      $(".secondary.plegadizo").addClass('hidden');
      $(".secondary.corrugado").addClass('hidden');
      $(".secondary.doble_corrugado").addClass('hidden');
      $(".secondary.otros").addClass('hidden');

    } else if (material == 'microcorrugado' ||
      material == 'single face' ||
      material == 'rígido' ||
      material == 'acetato' ||
      material == 'celofán') {
      $(".secondary.otros").removeClass('hidden');
      $(".secondary.plegadizo").addClass('hidden');
      $(".secondary.corrugado").addClass('hidden');
      $(".secondary.doble_corrugado").addClass('hidden');
      $(".secondary.liner").addClass('hidden');

    } else if (material == 'doble_corrugado') {
      $(".secondary.doble_corrugado").removeClass('hidden');
      $(".secondary.plegadizo").addClass('hidden');
      $(".secondary.corrugado").addClass('hidden');
      $(".secondary.otros").addClass('hidden');
      $(".secondary.liner").addClass('hidden');

    } else if (material == 'corrugado') {
      $(".secondary.corrugado").removeClass('hidden');
      $(".secondary.plegadizo").addClass('hidden');
      $(".secondary.doble_corrugado").addClass('hidden');
      $(".secondary.otros").addClass('hidden');
      $(".secondary.liner").addClass('hidden');
    };
  });

/* Este método esconde o muestra las resistencias, dependiendo de la elección del tipo de material elegido (tercer material)*/
  $("#request_third_material").bind('change', function() {
    var material = $("#request_third_material").val();

    if (material == 'reverso gris' ||
      material == 'reverso blanco' ||
      material == 'caple' ||
      material == 'sulfatada' ||
      material == 'multicapa') {
      $(".third.plegadizo").removeClass('hidden');
      $(".third.liner").addClass('hidden');
      $(".third.corrugado").addClass('hidden');
      $(".third.doble_corrugado").addClass('hidden');
      $(".third.otros").addClass('hidden');

    } else if (material == 'liner') {
      $(".third.liner").removeClass('hidden');
      $(".third.plegadizo").addClass('hidden');
      $(".third.corrugado").addClass('hidden');
      $(".third.doble_corrugado").addClass('hidden');
      $(".third.otros").addClass('hidden');

    } else if (material == 'microcorrugado' ||
      material == 'single face' ||
      material == 'rígido' ||
      material == 'acetato' ||
      material == 'celofán') {
      $(".third.otros").removeClass('hidden');
      $(".third.plegadizo").addClass('hidden');
      $(".third.corrugado").addClass('hidden');
      $(".third.doble_corrugado").addClass('hidden');
      $(".third.liner").addClass('hidden');

    } else if (material == 'doble_corrugado') {
      $(".third.doble_corrugado").removeClass('hidden');
      $(".third.plegadizo").addClass('hidden');
      $(".third.corrugado").addClass('hidden');
      $(".third.otros").addClass('hidden');
      $(".third.liner").addClass('hidden');

    } else if (material == 'corrugado') {
      $(".third.corrugado").removeClass('hidden');
      $(".third.plegadizo").addClass('hidden');
      $(".third.doble_corrugado").addClass('hidden');
      $(".third.otros").addClass('hidden');
      $(".third.liner").addClass('hidden');
    };
  });

  var clickCounter = 0;
  $("#agregar_material").click(function () {
    event.preventDefault();
    if (clickCounter == 0) {
      $(".field.secondary.hidden").removeClass('hidden');
      clickCounter +=1;
    } else if (clickCounter == 1) {
      $(".field.third.hidden").removeClass('hidden');
      clickCounter +=1;
    };
  });

  $("#request_impression_si").click(function () {
    $(".impression").removeClass('hidden');
  });

  $("#request_impression_no").click(function () {
    $(".impression").addClass('hidden');
  });

/* Este método esconde o muestra el buscador de resistencia, si elige sugerir resistencia */
  $("#request_resistance_main_material").bind('change', function() {
    var search = $("#request_resistance_main_material").val();
    if (search == 'Sugerir resistencia') {
      $("#resistencia_como").removeClass('hidden');
    } else if (search != 'Sugerir resistencia') {
      $("#resistencia_como").addClass('hidden');
    };
  });

});
