$(document).ready(function() {

  kgProducts = {};

  $("#generateEntry").prop("disabled", true);

  newRows = $(".newRow");
  action = $("#action").html();
  isStore = $("#is_store").html();
  wholesale_quantity = 999999999;
  can_write = false;

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
              "#normal_price_",
              "#wholesale_discount_",
              "#wholesale_quantity_",
              "#price_without_discount_",
              "#prospect_discount_"
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
              } else if ($(field).attr('id') == 'wholesale_discount_') {
                $(field).html(response.response[0][15]["wholesale_discount"]);
              } else if ($(field).attr('id') == 'wholesale_quantity_') {
                $(field).html(response.response[0][16]["wholesale_quantity"]);
              } else if ($(field).attr('id') == 'price_without_discount_') {
                $(field).html(response.response[0][17]["price_without_discount"]);
              } else if ($(field).attr('id') == 'prospect_discount_') {
                $(field).html(response.response[0][18]["prospect_discount"]);
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
    can_write = false;
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
        unarmedPrice = $('#price_without_discount_' + armedId).html();
        unarmedDiscount = $('#prospect_discount_' + armedId).html();
        $('#discount_' + armedId).html(parseFloat(unarmedDiscount).toFixed(1) + ' %');
        $('#unit_price_' + armedId).html("$ " + parseFloat(unarmedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('#base_unit_price_' + armedId).html("$ " + parseFloat(unarmedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('.second-check_' + armedId).prop("checked", true);
        rowTotal(armedId);
        realTotal();
      }
    } else {
      if (armedCheck.is(":checked")) {
        armedDiscount = $('#armed_discount_' + armedId).html();
        $('#discount_' + armedId).val(parseFloat(armedDiscount).toFixed(1));
        $('.second-check_' + armedId).prop("checked", false);
      } else {
        unarmedDiscount = $('#prospect_discount_' + armedId).html();
        $('#discount_' + armedId).val(parseFloat(unarmedDiscount).toFixed(1));
        $('.second-check_' + armedId).prop("checked", true);
      }
      rowTotal(armedId);
      realTotal();
    }
  });

  function addEvents(idProd){
    $("#close_icon_" + idProd).on("click", function(event) {
      var row = $(this).parent().parent();
      row.remove();
      realTotal();
      disableButton();
    });

    $("#packages_" + idProd).keyup(function(){
      rowTotal(idProd);
      disableButton();
    });

    $("#discount_" + idProd).keyup(function(){
      rowTotal(idProd);
      disableButton();
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
      if ($('#armed-group_' + idRow)[0].children[0].classList.contains("hidden")) {
        if (idRow in kgProducts) {
          discount = (parseFloat($('#discount_' + idRow).val()));
        } else {
          discount = (parseFloat($('#discount_' + idRow).val() / 100));
        }
      } else {
        discount = (parseFloat($('#prospect_discount_' + idRow).html()) / 100);
      }
      if (isNaN(discount)) {
        discount = 0;
      }
      if (isStore == "true") {
        wholesale_discount = parseFloat($("#wholesale_discount_" + idRow).text());
        wholesale_quantity = parseInt($("#wholesale_quantity_" + idRow).text());
        packs = parseInt($("#packages_" + idRow).val());
        if (isNaN(packs)) {
          packs = 0;
        }
        if (packs >= wholesale_quantity) {
          if (isStore == "true") {
            discount = wholesale_discount;
          }
          price = parseFloat($('#price_without_discount_' + idRow).html()) * (1 - (discount / 100));
          price = parseFloat(price.toFixed(2));
          if (!$('#armed-group_' + idRow)[0].children[0].classList.contains("hidden")) {
            $("#unit_price_" + idRow).html("$ " + price);
          }
        } else {
          if (isStore) {
            discount = parseFloat($('#discount_' + idRow).val());
            price = parseFloat($('#price_without_discount_' + idRow).html()) * (1 - (discount / 100));
            price = parseFloat(price.toFixed(2));
          } else {
            discount = parseFloat($('#normal_discount_' + idRow).html());
            price = $('#normal_price_' + idRow).html();
          }
          $('#discount_' + idRow).val(discount);
          if (isNaN(parseFloat(price))) {
            $("#unit_price_" + idRow).html("$ " + price.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
          } else {
            $("#unit_price_" + idRow).html("$ " + price);
          }

        }
      }
      if (idRow in kgProducts) {
        if (packs >= wholesale_quantity) {
          if (isStore == "true") {
            discount = wholesale_discount;
          }
          price = parseFloat($('#price_without_discount_' + idRow).html()) * (1 - (discount / 100));
          price = parseFloat(price.toFixed(2));
        } else {
          if (isStore == "true") {
            discount = parseFloat($('#prospect_discount_' + idRow).html());
            price = parseFloat($('#price_without_discount_' + idRow).html()) * (1 - (discount / 100));
            price = parseFloat(price.toFixed(2));
          } else {
            if (discount > parseFloat($('#prospect_discount_' + idRow).html())) {
              discount = discount;
              price = price;
            } else {
              discount = parseFloat($('#prospect_discount_' + idRow).html());
              price = $('#normal_price_' + idRow).html();
            }
          }
          $('#discount_' + idRow).val(discount);
          if (isNaN(parseFloat(price))) {
            $("#unit_price_" + idRow).html("$ " + price.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
          } else {
            $("#unit_price_" + idRow).html("$ " + price);
          }
        }
        $('#discount_' + idRow).val(discount);
        if (discount > 1) {
          unit_p = (parseFloat($("#base_unit_price_" + idRow).html()) * (1 - (discount / 100))).toFixed(2);
        } else {
          unit_p = (parseFloat($("#base_unit_price_" + idRow).html()) * (1 - discount)).toFixed(2);
        }
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
        if (isStore == "true") {
          if (packs >= wholesale_quantity) {
            $('#discount_' + idRow).val(wholesale_discount);
            discount = wholesale_discount / 100;
          } else {
            discount = parseFloat($('#prospect_discount_' + idRow).html());
            $('#discount_' + idRow).val(discount);
            discount = discount / 100;
          }

          if (!$('#armed-group_' + idRow)[0].children[0].classList.contains("hidden")) {
            if (!$('#armed_' + idRow).is(":checked")) {
              armedDiscount = $('#armed_discount_' + idRow).html();
              $('#discount_' + idRow).val(parseFloat(armedDiscount).toFixed(1));
              $('.second-check_' + idRow).prop("checked", false);
            } else {
//              unarmedDiscount = $('#normal_discount_' + idRow).html();
//              $('#discount_' + idRow).val(parseFloat(unarmedDiscount).toFixed(1));
//              $('.second-check_' + idRow).prop("checked", true);
            }
          }

        }
        price = (parseFloat($("#base_unit_price_" + idRow).html().replace("$ ", "").replace(/,/g,'')) * (1 - discount)).toFixed(2);
        $("#unit_price_" + idRow).html("$ " + price.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
      }

    } else {
      // added to new discount feature
      wholesale_discount = parseFloat($("#wholesale_discount_" + idRow).text());
      wholesale_quantity = parseInt($("#wholesale_quantity_" + idRow).text());
      packs = parseInt($("#packages_" + idRow).val());
      if (isNaN(packs)) {
        packs = 0;
      }
      // added to new discount feature
      if (packs >= wholesale_quantity) {
        discount = wholesale_discount
        price = parseFloat($('#price_without_discount_' + idRow).html()) * (1 - (discount / 100))
        price = parseFloat(price.toFixed(2))
      } else {
        discount = parseFloat($('#normal_discount_' + idRow).html());
        price = $('#normal_price_' + idRow).html();
      }
      if (idRow in kgProducts) {
        unit_p = parseFloat($("#price_without_discount_" + idRow).html()) * (1 - (discount / 100))
        unit_p = parseFloat(unit_p.toFixed(2))
        if (total_quantity != 0) {
          if (packs >= wholesale_quantity) {
            discount = wholesale_discount
            unit_p = parseFloat($("#price_without_discount_" + idRow).html()) * (1 - (discount / 100))
            unit_p = parseFloat(unit_p.toFixed(2))
          } else {
            discount = parseFloat($('#normal_discount_' + idRow).html());
            unit_p = unitPrice
            price = $('#normal_price_' + idRow).html();
          }
          if (total_quantity <= (kgProducts[idRow].length - 1)) {
            for(var index = 0; index < total_quantity; index++) {
              sum += parseFloat(Object.values(kgProducts[idRow][index]));
            }
            price = (sum * parseFloat(unit_p) / total_quantity).toFixed(2);
          } else {
            sum = Object.values(kgProducts[idRow][(kgProducts[idRow].length - 1)]) * total_quantity;
            price = (sum * unit_p / total_quantity).toFixed(2);
          }
        } else {
          price = 0;
        }
        $('#unit_price_' + idRow).html("$ " + parseFloat(unit_p).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
      } else {
        $('#unit_price_' + idRow).html("$ " + parseFloat(price).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
      }
      // Revisar esta línea para los productos armados
      $('#discount_' + idRow).html(parseFloat(discount).toFixed(1) + ' %');
    }
    wholesale_discount = parseFloat($("#wholesale_discount_" + idRow).text());
    wholesale_quantity = parseInt($("#wholesale_quantity_" + idRow).text());
    packs = parseInt($("#packages_" + idRow).val());
    if (isNaN(packs)) {
      packs = 0;
    }

    if (!$('#armed-group_' + idRow)[0].children[0].classList.contains("hidden")) {
      if (!$('#armed_' + idRow).is(":checked")) {
        armedPrice = $('#armed_price_' + idRow).html();
        armedDiscount = $('#armed_discount_' + idRow).html();
        $('#discount_' + idRow).html(parseFloat(armedDiscount).toFixed(1) + ' %');
        $('#unit_price_' + idRow).html("$ " + parseFloat(armedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('#base_unit_price_' + idRow).html("$ " + parseFloat(armedPrice).toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
        $('.second-check_' + idRow).prop("checked", false);
        $('#discount_' + idRow).html(parseFloat(armedDiscount).toFixed(1) + ' %');
        price = armedPrice;
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

      can_write = true;
      return bigTotal;
    });
  }

});
