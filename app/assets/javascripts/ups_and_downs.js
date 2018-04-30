$(document).ready(function() {

  kgProducts = {};

  $("#generateEntry").prop("disabled", true);

  action = $("#action").html();
  newRows = $(".newRow");

  $.ajax({
    url: '/api/get_just_products',
  })
  .done(function(response){
    $('.select-product').autocomplete({
      lookup: response.suggestions,
      onSelect: function (suggestion) {
        $.ajax({
          url: '../api/get_info_from_product/' + suggestion.data,
          method: 'get'
        }).done(function(response) {
          $("#unique_code_").val('');
          isKgProduct = response.response[0][9]["kg"];
          if (isKgProduct) {
            if (suggestion.data in kgProducts) {
              kgProducts[suggestion.data] += 1;
            } else {
              kgProducts[suggestion.data] = 0;
            }
            this_id = suggestion.data + "_" + kgProducts[suggestion.data];
          } else {
            this_id = suggestion.data;
          }
          product_count = $("#row" + this_id).length;
          if (product_count < 1) {
            var clone = newRows.clone();
            clone.attr('id', 'row' + this_id);
            $("#fields_for_warehouse_entries").append(clone);
            fields = [
              "#close_icon_",
              "#description_",
              "#quantity_",
              "#vincularSupplier",
              "#id_",
              "#folio_",
              "#date_of_bill_",
              "#total_amount_",
              "#taxes_rate_",
              "#subtotal_",
              "#supplier_",
              "#actualInventory_",
              "#separatedInventory_",
              "#totalInventory_",
              "#reason_",
              "#kg_",
              "#kg_field_",
            ]
            fields.forEach(function(field) {
              if ($(field).attr('id') == 'description_') {
                $(field).html(response.response[0][0]["description"]);
              } else if ($(field).attr('id') == 'id_') {
                $(field).val(this_id);
              } else if ($(field).attr('id') == 'actualInventory_') {
                $(field).html(response.response[0][3]["inventory"]);
              } else if ($(field).attr('id') == 'separatedInventory_') {
                $(field).html(response.response[0][7]["separated"]);
              } else if ($(field).attr('id') == 'totalInventory_') {
                $(field).html(response.response[0][8]["total_inventory"]);
              } else if ($(field).attr('id') == 'kg_field_') {
                if (isKgProduct) {
                  $(field).removeClass("hidden");
                  $(".weightKg").removeClass("hidden");
                }
              }
              $(field).attr('id', field.replace("#", "") + this_id);
            });
            $("#vincularSupplier" + this_id).attr("data-id", this_id);
          } // product_count

          rowTotal(this_id);
          addEvents(this_id);
          enableButton();
        }); //done function (response) segundo ajax
      } // onselect
    }); // autocomplete
  }); // done function (response)


  function addEvents(idProd){
    $("#close_icon_" + idProd).on("click", function(event) {
      let row = $(this).parent().parent();
      row.remove();
      enableButton();
    });

    if (action == 'remove_inventory') {
      $('[id^=quantity_]').on('keyup', function(){
        let id = $(this).attr('id').replace('quantity_', '');
        let limitValue = parseInt($(this).parent().parent().find('#totalInventory_' + id).html());
        let tryValue = parseInt($(this).val());
        if ( tryValue > limitValue ){
          $(this).val(limitValue);
        }
      });
    }

    $("#quantity_" + idProd).keyup(function(){
      rowTotal(idProd);
      enableButton();
    });
  }



  $('#checkPercent').change(function(){
    calculateSubtotal();
  });

  $('#supplier_taxes_rate').keyup(function(){
    calculateSubtotal();
  });

  $('#supplier_subtotal').keyup(function(){
    calculateSubtotal();
  });

  function rowTotal(idRow){
    quantity = parseInt($("#quantity_" + idRow).val());
    if (isNaN(quantity)) {
      quantity = 0;
    }
  }

  function enableButton() {
    // Falta una validación para las bajas (agregar que valide motivo para dejar agregar)

    $("#generateEntry").prop("disabled", true);
    validation = [];

    if ($("[id^=vincularSupplier]").length > 0) {
      $.each($("[id^=vincularSupplier]"), function(){
        myId = $(this).attr("id").replace("vincularSupplier", "");
        if (myId != "") {
          myQuantity = parseInt($("#quantity_" + myId).val());
          if ($(this).hasClass("green") && (myQuantity > 0 || !isNaN(myQuantity) ) ) {
            validation.push(1);
          } else {
            validation.push(0);
          }
        }
      });
    } else {
      $.each($("[id^=quantity_]"), function(){
        my_Id = $(this).attr("id").replace("quantity_", "");
        my_Quantity = parseInt($("#quantity_" + my_Id).val());
        if (my_Id != "") {
          if (my_Quantity > 0 || !isNaN(my_Quantity)) {
            validation.push(1);
          } else {
            validation.push(0);
          }
        }
      });
    }
    if (validation.length > 0) {
      result = !!validation.reduce(function(a, b){ return (a === b) ? a : NaN; });
      if (result == true && validation[0] == 1) {
        $("#generateEntry").prop("disabled", false);
      } else  {
        $("#generateEntry").prop("disabled", true);
      }
    }
  }

  var calculateSubtotal = function(){
    var total = parseFloat($('input#supplier_total_amount').val().replace(/,/,''));
    var taxesRate = ((100 +  parseFloat($('input#supplier_taxes_rate').val()) ) / 100);

    if (!$('#checkPercent').is(':checked')){
      taxesRate = parseFloat($('input#supplier_taxes_rate').val());
      $('#supplier_subtotal').val((total - taxesRate).toFixed(2));
    } else {
      $('#supplier_subtotal').val((total / taxesRate).toFixed(2));
    }
    $('#supplier_subtotal').maskMoney();
  };

  $('#supplierModal').on('show.bs.modal', function (e) {

    $.ajax({
      url: '/api/get_all_suppliers_for_corporate',
    })
    .done(function(response){
      $('#suppliersAutocomplete').autocomplete({
        lookup: response.suggestions,
        onSelect: function (suggestion) {

          $('.toShowOnSelect').removeClass("hidden");

          $("#supplierName").val(
            suggestion.value
          );

          $("#supplierId").val(
            suggestion.data
          );

          $('#suppliersAutocomplete').val('');
        }
      });
    });

      my_id = $(e.relatedTarget).attr('data-id');
      $("#productId").val(
        my_id
      );
      $('input#supplier_taxes_rate').val(
        16.0
      );

      $("#supplier_total_amount").val(
        0.0
      );

      // Aquí uso .one click por el ajax que duplica o triplica las cosas
      $('#addSupplierToForm').one('click', function() {
        $(e.relatedTarget).addClass("green");

        $('#folio_' + my_id).val(
          $('#supplier_folio').val()
        );
        $('#date_of_bill_' + my_id).val(
          $('#supplier_date_of_bill').val()
        );
        $('#subtotal_' + my_id).val(
          $('#supplier_subtotal').val()
        );
        $('#taxes_rate_' + my_id).val(
          $('#supplier_taxes_rate').val()
        );
        $('#total_amount_' + my_id).val(
          $('#supplier_total_amount').val()
        );
        $('#supplier_' + my_id).val(
          $('#supplierId').val()
        );
        $('#supplier_folio').val('');
        $('#supplier_date_of_bill').val('');
        $('#supplier_subtotal').val('');
        $('#supplier_taxes_rate').val('');
        $('#supplier_total_amount').val('');
        $('#supplierId').val('');
        $('#supplierName').val('');
        $('#supplierModal').modal('hide');
        rowTotal(my_id);
        enableButton();
      });

  });

  $('#myModal').on('hide.bs.modal', function (e) {
    $('.toShowOnSelect').addClass("hidden");
  });


});
