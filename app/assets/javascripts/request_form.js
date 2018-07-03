var actionForRequest = $("body.requests.new") || $("body.requests.edit") || $('body.products.new') || $('body.products.edit');

$(document).ready(function() {

/* Este método esconde o muestra las opciones, dependiendo de la elección del tipo de producto, por ejepmlo: medidas externas, medidas de bolsa, medidas de exhibidor, etc. */
  $("#request_product_type").bind('change', function() {
    var productType = $(this).val();

    if (productType == 'otro') {
      $(".otro").removeClass('hidden');
      $(".measures").removeClass('hidden');
      $("#outer").removeClass('hidden');
      $(".caja").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $(".resistance.main.bolsa").removeClass('hidden');
      $(".resistance.secondary.bolsa").removeClass('hidden');
      $(".resistance.third.bolsa").removeClass('hidden');
      $(".resistance.main.caja").removeClass('hidden');
      $(".resistance.secondary.caja").removeClass('hidden');
      $(".resistance.third.caja").removeClass('hidden');
      $("#field_design").addClass('hidden');

    } else if (productType == 'caja') {
      $(".caja").removeClass('hidden');
      $(".measures").removeClass('hidden');
      $("#outer").removeClass('hidden');
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
      $(".resistance.secondary.bolsa").addClass('hidden');
      $(".resistance.third.bolsa").addClass('hidden');
      $("#field_design").removeClass('hidden');

    } else if (productType == 'bolsa') {
      if (actionForRequest == $(".requests.edit")) {
        $('.new_option').detach();
      } else {
        $('.new_option').remove();
      };
      $(".bolsa").removeClass('hidden');
      $(".resistance.main.bolsa").removeClass('hidden');
      $(".resistance.secondary.bolsa").removeClass('hidden');
      $(".resistance.third.bolsa").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $("#outer").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $(".resistance.main.caja").addClass('hidden');
      $("#field_design").addClass('hidden');

    } else if (productType == 'exhibidor') {
      if (actionForRequest == $(".requests.edit")) {
        $('.new_option').detach();
      } else {
        $('.new_option').remove();
      };
      $(".exhibidor").removeClass('hidden');
      $(".measures").addClass('hidden');
      $(".otro").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
      $("#outer").addClass('hidden');
      $("#field_design").addClass('hidden');

    } else if (productType == 'seleccione') {
      if (actionForRequest == $(".requests.edit")) {
        $('.new_option').detach();
      } else {
        $('.new_option').remove();
      };
      $(".otro").addClass('hidden');
      $(".measures").addClass('hidden');
      $(".bolsa").addClass('hidden');
      $(".caja").addClass('hidden');
      $(".exhibidor").addClass('hidden');
      $("#outer").addClass('hidden');
      $(".measures").addClass('hidden');
      $(".resistance.main.bolsa").addClass('hidden');
      $("#field_design").addClass('hidden');
    };

  });

/* Este método esconde o muestra las opciones, dependiendo de la elección del tipo de medidas (internas o extenras) */
  $("#request_what_measures").bind('change', function() {
    var measures = $("#request_what_measures").val();

    if (measures == ''|| measures == 4) {
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
      $(".sometimes").removeClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'liner' || material == 'liner bond') {
      $(".main.liner").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".sometimes").removeClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'single face' ||
      material == 'microcorrugado' ||
      material == 'acetato' ||
      material == 'contraencolado' ||
      material == 'papel kraft' ||
      material == 'papel bond') {
      $(".main.otros").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".sometimes").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.liner").addClass('hidden');

    } else if (material == 'cartón rígido') {
      $(".main.rigid").removeClass('hidden');
      $(".rigid").removeClass('hidden');
      $(".main.otros").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".sometimes").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.liner").addClass('hidden');

    } else if (material == 'doble corrugado') {
      $(".main.doble_corrugado").removeClass('hidden');
      $(".sometimes").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'corrugado') {
      $(".main.corrugado").removeClass('hidden');
      $(".sometimes").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');
    };
  });

  $("#product_main_material").bind('change', function() {
    var material = $("#product_main_material").val();

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

    } else if (material == 'liner' || material == 'liner bond') {
      $(".main.liner").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.otros").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'cartón rígido' ||
      material == 'single face' ||
      material == 'microcorrugado' ||
      material == 'acetato' ||
      material == 'contraencolado' ||
      material == 'papel kraft' ||
      material == 'papel bond') {
      $(".main.otros").removeClass('hidden');
      $(".main.plegadizo").addClass('hidden');
      $(".main.corrugado").addClass('hidden');
      $(".main.doble_corrugado").addClass('hidden');
      $(".main.liner").addClass('hidden');
      $(".main.rigid").addClass('hidden');

    } else if (material == 'doble corrugado') {
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

    } else if (material == 'liner' || material == 'liner bond') {
      $(".secondary.liner").removeClass('hidden');
      $(".secondary.plegadizo").addClass('hidden');
      $(".secondary.corrugado").addClass('hidden');
      $(".secondary.doble_corrugado").addClass('hidden');
      $(".secondary.otros").addClass('hidden');

    } else if (material == 'cartón rígido' ||
      material == 'single face' ||
      material == 'microcorrugado' ||
      material == 'acetato' ||
      material == 'contraencolado' ||
      material == 'papel kraft' ||
      material == 'papel bond') {
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

    } else if (material == 'liner' || material == 'liner bond') {
      $(".third.liner").removeClass('hidden');
      $(".third.plegadizo").addClass('hidden');
      $(".third.corrugado").addClass('hidden');
      $(".third.doble_corrugado").addClass('hidden');
      $(".third.otros").addClass('hidden');

    } else if (material == 'cartón rígido' ||
      material == 'single face' ||
      material == 'microcorrugado' ||
      material == 'acetato' ||
      material == 'contraencolado' ||
      material == 'papel kraft' ||
      material == 'papel bond') {
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

  $("#agregar_material").click(function () {
    event.preventDefault();
    if ($(".field.secondary").hasClass('hidden') && $(".field.third").hasClass('hidden')) {
      $(".field.secondary").removeClass('hidden');
      $("#quitar_material").removeClass('hidden');
    } else if (!($(".field.secondary").hasClass('hidden')) && $(".field.third").hasClass('hidden')) {
      $(".field.third").removeClass('hidden');
      $("#agregar_material").addClass('hidden');
    }
  });

  $("#quitar_material").click(function () {
    event.preventDefault();
    if (!($(".field.secondary").hasClass('hidden')) && !($(".field.third").hasClass('hidden'))) {
      $(".field.third").addClass('hidden');
      $("#agregar_material").removeClass('hidden');
    } else if (!($(".field.secondary").hasClass('hidden')) && ($(".field.third").hasClass('hidden'))) {
      $(".field.secondary").addClass('hidden');
      $("#quitar_material").addClass('hidden');
      $("#agregar_material").removeClass('hidden');
    }
  });

$("#request_impression_si").click(function () {
  $(".impression").removeClass('hidden');
});

$("#request_impression_no").click(function () {
  $(".impression").addClass('hidden');
});

/* Este método esconde o muestra el buscador de resistencia, si elige buscar resistencia */
  $("#request_resistance_main_material").bind('change', function() {
    var search = $("#request_resistance_main_material").val();
    if (search == 'buscar') {
      $("#resistencia_como").removeClass('hidden');
    } else if (search != 'buscar') {
      $("#resistencia_como").addClass('hidden');
    };
  });

/* Este método esconde o muestra el checkbox de autorizaciones manuales */
  var authorisation = $('#request_authorisation');
  var payment = $('#request_payment');
  var printcard = $('#request_printcard');
  var authorisedWithoutDoc = $('#request_authorised_without_doc');
  var authorisedWithoutPay = $('#request_authorised_without_pay');
  var authorisedWithoutPrincard = $('#request_authorised_without_printcard');

  authorisedWithoutDoc.bind('change', function() {
    if (authorisedWithoutDoc.is(":checked")) {
      if (authorisation != '' ){
        $('.upload_authorisation').addClass('hidden');
      }
    } else {
      $('.upload_authorisation').removeClass('hidden');
    }
  });

  authorisedWithoutPay.bind('change', function() {
    if (authorisedWithoutPay.is(":checked")) {
      if (payment != '' ){
        $('.upload_payment').addClass('hidden');
      }
    } else {
      $('.upload_payment').removeClass('hidden');
    }
  });

  authorisedWithoutPrincard.bind('change', function() {
    if (authorisedWithoutPrincard.is(":checked")) {
      if (printcard != '' ){
        $('.upload_printcard').addClass('hidden');
      }
    } else {
      $('.upload_printcard').removeClass('hidden');
    }
  });

  if (($("body").hasClass('requests') && $("body").hasClass('new')) || ($("body").hasClass('requests') && $("body").hasClass('edit'))) {
    $('.select2-finishing').select2({
       placeholder: 'Máximo 2',
       language: "es",
       maximumSelectionLength: 2
    });
  }

});
