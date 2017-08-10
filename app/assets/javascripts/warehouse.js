$(function(){

  var initValidation = function(){
    $('#contact_form').bootstrapValidator({
      feedbackIcons: {
        valid: 'glyphicon glyphicon-ok',
        invalid: 'glyphicon glyphicon-remove',
        validating: 'glyphicon glyphicon-refresh'
      },
      fields: {
        first_name: {
          validators: {
            stringLength: {
              min: 2,
            },
            notEmpty: {
              message: 'Please supply your first name'
            }
          }
        },
      }
    });
  };

  if ($('.datatables').length > 0) {
    $('.datatables').DataTable({
      "language": {
        "sProcessing":     "Procesando...",
        "sLengthMenu":     "Mostrar _MENU_ registros",
        "sZeroRecords":    "No se encontraron resultados",
        "sEmptyTable":     "Ningún dato disponible en esta tabla",
        "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
        "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
        "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
        "sInfoPostFix":    "",
        "sSearch":         "Buscar:",
        "sUrl":            "",
        "sInfoThousands":  ",",
        "sLoadingRecords": "Cargando...",
        "oPaginate": {
          "sFirst":    "Primero",
          "sLast":     "Último",
          "sNext":     "Siguiente",
          "sPrevious": "Anterior"
        },
        "oAria": {
          "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendente"
        }
      },
      pageLength: 10,
      responsive: true,
      dom: 'Bfrtip',
      buttons: [
        'copy', 'csv', 'excel', 'pdf'
      ]
    });
  }

  var formatState = function(state){
    var r = /\d+/;
    var code = state.text.match(r);
    if (state.text === 'Selecionar un producto') {
      return state.text;
    }
    if (state.id === '') {
      return state.text;
    }
    var element = $('#' + state.element.parentElement.id);
    if (findInSelect($(element).val(), $(element).attr('id'))) {
      return '';
    }
    return code;
  };

  var checkNotEmpty = function(){
    var allFill = true;
    $.each($('input[id^=numProduct_product]'), function(){
      if ($(this).val() === ''){
        allFill = false;
        $(this).parent().addClass('has-error');
      } else {
        $(this).parent().removeClass('has-error').addClass('has-success');
      }
    });
    return allFill;
  };

  var createProductData = function(supplier){
    var data = {};
    $.each($('tr[id^=trForProduct]'), function(){
      data[$(this).attr('id')] = {
        id       : $(this).find('select').val(),
        cantidad : $(this).find('input[id^=numProduct]').val()
      };
      if (supplier) {
        data[$(this).attr('id')].supplierInfo = $('#supplierInfo').html();
      }
    });
    return data;
  };


  $('#saveInfo').click(function(){
    var data = createProductData(false);
    if (checkNotEmpty()){
      $.ajax({
        url: '/warehouse/save_own_product',
        data: data,
        method: 'post'
      });
    }
    return false;
  });

  var findInSelect = function(findCode, id){
    var find = false;
    $.each($('select'), function(){
      if ($(this).val().toString() === findCode.toString() && $(this).attr('id') !== id){
        find = true;
        return true;
      }
    });
    return find;
  };

  var changeAction = function(element, inc, dec){
    if ($(element).val() === null) {
      var tr = $('td[id$=product'+dec+']').parent();
      var selectId = $(tr).find('select').attr('id');
      if ($('tbody tr').length > 1) {
        $('#' + selectId).select2('destroy');
        $(tr).remove();
      } else {
        $(tr).find('td').slice(-4).remove();
      }
    } else {
      _.templateSettings = {
        interpolate: /\{\{\=(.+?)\}\}/g,
        evaluate: /\{\{(.+?)\}\}/g,
        variable: 'rc'
      };
      if (findInSelect($(element).val(), $(element).attr('id'))) {
        return false;
      }
      $.ajax({
        url: '/warehouse/get/' + $(element).val(),
        method: 'get'
      }).done(function(response) {
        var template = _.template(
          $("script.template").html()
        );
        var image = response.images.length > 0 ?
          response.images[0].image.small.url :
          $('#not_image_temp').attr('src');
        var link = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
        var id = "product" + dec;
        $('#trForProduct' + dec).append(
          template( {
            description: response.product.description,
            image:       image,
            link:        link,
            id:          id
          } )
        );

        if ($('#suppliersList')) {
          $(document).on("click", "#vincularSupplier" + id, function () {
            var productId = $(this).data('id');
            $(".modal-body #supplierId").val( productId );
            $('#supplierModal').modal('show');
          });
        }

        $('#numProduct_'+ id).mask("000", {placeholder: "___"}).css({'text-align': 'center'});
        $('#addNew' + id).click(function(){
          var tr = "<tr id='trForProduct"+ inc +"'>" +
            "<td class='select'>" +
            "<select id='selectForProduct"+ inc +"'></select>" +
            "</td>" +
            "</tr>";
          $('tbody').prepend(tr);
          $('#selectForProduct'+ inc).append($('#trForProduct1 select').html());
          $('#selectForProduct'+ inc).select2({
            templateSelection: formatState,
            multiple: true,
            maximumSelectionLength: 1
          })
            .change(function(){
              var dec = parseInt($(this).attr('id').match(/\d+/)[0]);
              changeAction(this, dec + 1, dec);
            });
          $(this).addClass('hidden');
          return false;
        });
      });
    }
  };

  if ($('#product1').length > 0) {
    setTimeout(function(){
      $('#product1').select2({
        templateSelection: formatState,
        multiple: true,
        maximumSelectionLength: 1
      })
      .change(function(){
        changeAction(this, 2, 1);
      });

      if ($('#suppliersList')) {

        $('#suppliersList').select2({
          width: 500
        });

        $('#vinculateSupplier').click(function(){

          var info =  $('#suppliersList').val() +              ',' +
                      $('input#supplier_folio').val() +        ',' +
                      $('input#supplier_date_of_bill').val() + ',' +
                      $('input#supplier_subtotal').val() +     ',' +
                      $('input#supplier_taxes_rate').val() +   ',' +
                      $('input#supplier_total_amount').val();
          $('#supplierInfo' + $('input#supplierId').val()).html(info);

          $('#suppliersList').val('').trigger('change.select2');
          $('input#supplier_folio').val('');
          $('input#supplier_date_of_bill').val('');
          $('input#supplier_subtotal').val('');
          $('input#supplier_taxes_rate').val('');
          $('input#supplier_total_amount').val('');

          $('#supplierModal').modal('toggle');

        });

        $('#saveInfoSupplier').click(function(){
          var data = createProductData(true);
          if (checkNotEmpty()){
            $.ajax({
              url: '/warehouse/save_supplier_product',
              data: data,
              method: 'post'
            });
          }
          return false;
        });
      }
    }, 200);

  }

});
