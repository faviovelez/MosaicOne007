$(document).ready(function() {

  kgProducts = {};

  $("#generateEntry").prop("disabled", true);

  newRows = $(".newRow");
  action = $("#action").html();

  $.ajax({
    url: '/api/get_just_products',
  })
  .done(function(response){
    $('.select-product').autocomplete({
      lookup: response.suggestions,
      onSelect: function (suggestion) {
        if ($('#ProspectId').html() == undefined) {
          var url = '/api/get_info_from_product_store/' + suggestion.data + '/' + $('#corporate_store').val() + '/' + $('#storeId').html().replace(/ /g,"");
        } else {
          var url = '/api/get_info_from_product_with_prospect/' + suggestion.data + '/' + $('#corporate_store').val() + '/' + $('#ProspectId').html().replace(/ /g,"");
        }
        $.ajax({
          url: url,
          method: 'get'
        })
        .done(function(response) {
          $("#unique_code_").val('');
          $("#totalRow").removeClass("hidden");
          isKgProduct = response.response[0][9]["kg"];
          isArmedProduct = response.response[0][12]["armed"];
          product_count = $("#row" + suggestion.data).length;
          if (product_count < 1) {
            var clone = newRows.clone();
            clone.attr('id', 'row' + suggestion.data);
            this_id = suggestion.data;
            $("#fields_for_warehouse_entries").prepend(clone);
            fields = [
              "#close_icon_",
              "#description_",
              "#color_",
              "#unit_price_",
              "#base_unit_price_",
              "#pieces_per_package_",
              "#products_",
              "#inventory_",
              "#packages_",
              "#request_",
              "#discount_",
              "#status_",
              "#total_",
              "#armed_",
              "#armed_discount_",
              "#armed_price_",
              "#normal_discount_",
              "#normal_price_"
            ]
            fields.forEach(function(field) {
              if ($(field).attr('id') == 'description_') {
                $(field).html(response.response[0][0]["description"]);
              } else if ($(field).attr('id') == 'products_') {
                $(field).val(this_id);
              } else if ($(field).attr('id') == 'color_') {
                $(field).html(response.response[0][2]["color"]);
              } else if ($(field).attr('id') == 'inventory_') {
                $(field).html(response.response[0][3]["inventory"]);
              } else if ($(field).attr('id') == 'discount_') {
                if (action == 'new_order_for_prospects') {
                  discountRow = parseFloat($("#discountForProspect").html());
                  $(field).val(discountRow);
                } else {
                  discountRow = response.response[0][6]["discount"].toFixed(1);
                  $(field).html(discountRow + " %");
                }
              } else if ($(field).attr('id') == 'normal_discount_') {
                if (action == 'new_order_for_prospects') {
                  discountRow = 0;
                  $(field).val(discountRow);
                } else {
                  discountRow = response.response[0][6]["discount"].toFixed(1);
                  $(field).html(discountRow);
                }
              } else if ($(field).attr('id') == 'unit_price_') {
                unitPrice = response.response[0][1]["price"].toFixed(2)
                .replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                $(field).html("$ " + unitPrice);
              } else if ($(field).attr('id') == 'base_unit_price_') {
                unitPrice = response.response[0][1]["price"].toFixed(2);
                $(field).html(unitPrice);
              } else if ($(field).attr('id') == 'normal_price_') {
                unitPrice = response.response[0][1]["price"].toFixed(2);
                $(field).html(unitPrice);
              } else if ($(field).attr('id') == 'pieces_per_package_') {
                $(field).html(response.response[0][4]["packages"]);
              } else if ($(field).attr('id') == 'armed_price_') {
                $(field).html(response.response[0][13]["armed_price"]);
              } else if ($(field).attr('id') == 'armed_discount_') {
                $(field).html(response.response[0][14]["armed_discount"]);
              }
              $(field).attr('id', field.replace("#", "") + this_id);
            });
            if (action == 'new_order_for_prospects') {
              $("#discount_" + this_id).inputmask("decimal");
            }
            $("#packages_" + this_id).inputmask("integer");
            checkSelector = $('#row' + this_id).find('.checkboxes');
            checkSelector.attr('id', 'armed-group_' + this_id);
            checkSelector.attr('class', 'checkboxes hidden armed-group_' + this_id);
            visibleCheck = checkSelector.find('.armed-check');
            invisibleCheck = checkSelector.find('.second-check_');
            visibleCheck.attr('id', 'armed-group_' + this_id);
            invisibleCheck.attr('id', 'armed_' + this_id);
            visibleCheck.attr('class', 'armed-check alter-hidden hidden armed-group_' + this_id);
            invisibleCheck.attr('class', 'alter-hidden second-check_' + this_id);
            if (!($('.armed-group-title').hasClass('hidden'))) {
              $('.checkboxes').removeClass('hidden');
            }
            if (isKgProduct) {
              kgProducts[this_id] = response.response[0][10]["availability"];
            } else if (isArmedProduct) {
              $('.total-row').attr('colspan', '10');
              $('.armed-group-title').removeClass('hidden');
              $('.checkboxes').removeClass('hidden');
              $('.armed-group_' + this_id).removeClass('alter-hidden');
              $('.armed-group_' + this_id).removeClass('hidden');
              $('.armed-group_' + this_id).addClass('armed-check');
              $(".second-check_" + this_id).addClass('alter-hidden');
            }
          }
          rowTotal(this_id);
          disableButton();
          addEvents(this_id);
        }); // donde function(response) second ajax
      } // onSelect function(suggestion)
    }); // autocomplete
  }); // done function (response) first ajax

// AGREGAR QUE JALE AUTOMÁTICAMENTE EL PORCENTAJE DE DESCUENTO DEL CLIENTE
// PARA ESO HAY QUE CREAR UN NUEVO CLIENTE EN TIENDA 1

  $("body").on('change', 'input[type="checkbox"]', function() {
    var armedId = $(this).attr('id').replace('armed-group_', '');
    var armedCheck = $(this);
    if (action != 'new_order_for_prospects') {
      if (armedCheck.is(":checked")) {
        armedPrice = $('#armed_price_' + armedId).html();
        armedDiscount = $('#armed_discount_' + armedId).html();
        $('#discount_' + armedId).html(parseFloat(armedDiscount).toFixed(1) + ' %');
        $('#unit_price_' + armedId).html("$ " + parseFloat(armedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('#base_unit_price_' + armedId).html("$ " + parseFloat(armedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('.second-check_' + armedId).prop("checked", false);
        rowTotal(armedId);
        realTotal();
      } else {
        unarmedPrice = $('#normal_price_' + armedId).html();
        unarmedDiscount = $('#normal_discount_' + armedId).html();
        $('#discount_' + armedId).html(parseFloat(unarmedDiscount).toFixed(1) + ' %');
        $('#unit_price_' + armedId).html("$ " + parseFloat(unarmedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('#base_unit_price_' + armedId).html("$ " + parseFloat(unarmedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('.second-check_' + armedId).prop("checked", true);
        rowTotal(armedId);
        realTotal();
      }
    } else {
      if (armedCheck.is(":checked")) {
        $('.second-check_' + armedId).prop("checked", false);
      } else {
        $('.second-check_' + armedId).prop("checked", true);
      }
    }
  });

  function addEvents(idProd){
    $("#close_icon_" + idProd).on("click", function(event) {
      var row = $(this).parent().parent();
      row.remove();
      realTotal();
    });

    $("#packages_" + idProd).keyup(function(){
      rowTotal(idProd);
      disableButton();
    });

    $("#discount_" + idProd).keyup(function(){
      rowTotal(idProd);
    });
  }

  function disableButton(){
    $.each($("[id^=packages_]"), function(){
      if ($(this).attr("id").replace("packages_", "") != "") {
        if (isNaN(parseInt($(this).val()))) {
          $("#generateEntry").prop("disabled", true);
          return false;
        } else {
          $("#generateEntry").prop("disabled", false);
        };
      }
    });
  }

  function rowTotal(idRow){

    packs = parseInt($("#packages_" + idRow).val());
    if (isNaN(packs)) {
      packs = 0;
    }
    pieces = parseInt($("#pieces_per_package_" + idRow).html());
    total_quantity = packs * pieces;

    $("#request_" + idRow).val(
      total_quantity
    );

    actual_inventory = parseInt($("#inventory_" + idRow).html());
    converted_inventory = actual_inventory.toFixed(0)
    .replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");

    if (actual_inventory == 0 || total_quantity > actual_inventory) {
      if (actual_inventory > 0) {
        warning = "Solo hay disponibles " + converted_inventory + " piezas";
      } else if (actual_inventory < 1) {
        warning = "Este producto no está disponible por el momento";
      }
      $("#status_" + idRow).html(
        '<span class="label label-warning"' +
        'data-toggle="tooltip" data-placement="left">' +
        'No disponible</span>'
      ).attr("title", warning);
    } else {
      $("#status_" + idRow).html(
        '<span class="label label-success">Disponible</span>'
      ).attr("title", "");
    }

    sum = 0;
    if (action == 'new_order_for_prospects') {
      discount = (parseFloat($('#discount_' + idRow).val()) / 100);
      if (isNaN(discount)) {
        discount = 0;
      }
      if (idRow in kgProducts) {
        unit_p = (parseFloat($("#base_unit_price_" + idRow).html()) * (1 - discount)).toFixed(2);
        if (total_quantity != 0) {
          if (total_quantity <= (kgProducts[idRow].length - 1)) {
            for(var index = 0; index < total_quantity; index++) {
              sum += parseFloat(Object.values(kgProducts[idRow][index]));
            }
            price = (sum * unit_p / total_quantity).toFixed(2);
          } else {
            sum = Object.values(kgProducts[idRow][(kgProducts[idRow].length - 1)]) * total_quantity;
            price = (sum * unit_p / total_quantity).toFixed(2);
          }
        } else {
          price = "0.00";
        }
        $("#unit_price_" + idRow).html("$ " + unit_p.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
      } else {
        price = (parseFloat($("#base_unit_price_" + idRow).html()) * (1 - discount)).toFixed(2);
        $("#unit_price_" + idRow).html("$ " + price.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
      }

    } else {
      if (idRow in kgProducts) {
        if (total_quantity != 0) {
          unit_p = parseFloat($("#unit_price_" + idRow).html()
          .replace("$ ", "").replace(/,/g,'')
        );
          if (total_quantity <= (kgProducts[idRow].length - 1)) {
            for(var index = 0; index < total_quantity; index++) {
              sum += parseFloat(Object.values(kgProducts[idRow][index]));
            }
            price = (sum * unit_p / total_quantity).toFixed(2);
          } else {
            sum = Object.values(kgProducts[idRow][(kgProducts[idRow].length - 1)]) * total_quantity;
            price = (sum * unit_p / total_quantity).toFixed(2);
          }
        } else {
          price = 0;
        }

      } else {
        price = parseFloat($("#unit_price_" + idRow).html()
        .replace("$ ", "").replace(/,/g,'')
        );
      }
    }

    total_request = (price * total_quantity) * 1.16;

    converted_total_request = total_request.toFixed(2)
    .replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");

    $("#total_" + idRow).html("$ " + converted_total_request);

    realTotal();
  }

  function realTotal(){
    bigTotal = 0;

    $.each($("[id^=total_]"), function(){
      var thisAmount = parseFloat($(this).html()
        .replace("$ ", "").replace(/,/g,''));
      if (isNaN(thisAmount)) {
        thisAmount = 0;
      }

      bigTotal += thisAmount;

      converted_big_total = (bigTotal).toFixed(2)
      .replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");

      $("#strongTotal").html("$ " + converted_big_total);

      return bigTotal;
    });
  }

});
