$(document).ready(function(){
  var tableOne = $('.dataTable').DataTable({
    "order": [[ 1, "asc" ]],
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
    dom: 'Bfrtip',
    buttons: [
      'pdfHtml5'
    ]
  });

  var tableTwoClone = $('.dataTableNoPaginationTwo').DataTable({
    "order": [[ 1, "asc" ]],
    stateSave: true,
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
    dom: 'Bfrtip',
    "drawCallback": function(settings){

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

    },
    buttons: [
      {
        extend: 'print',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4]
        }
      },
      {
        extend: 'pdf',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4]
        }
      }
    ]
  });

  var tableTwo = $('.dataTableNoPagination').DataTable({
    "order": [[ 1, "asc" ]],
    stateSave: true,
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
    dom: 'Bfrtip',
    "drawCallback": function(settings){
      tableTwoPresent = true;
      if ($('#order_complete').length > 0) {
        if ($('#order_complete').is(":checked")) {
          $(".all-hide").addClass("hidden");
        } else {
          $(".all-hide").removeClass("hidden");
        }
      }
    },
    buttons: [
      {
        extend: 'print',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4]
        }
      },
      {
        extend: 'pdf',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4]
        }
      }
    ]
  });

  var tableTwo = $('.dataTableNoPaginationThree').DataTable({
    "order": [[ 1, "asc" ]],
    stateSave: true,
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
    dom: 'Bfrtip',
    "drawCallback": function(settings){
      tableTwoPresent = true;
      if ($('#order_complete').length > 0) {
        if ($('#order_complete').is(":checked")) {
          $(".all-hide").addClass("hidden");
        } else {
          $(".all-hide").removeClass("hidden");
        }
      }
    },
    buttons: [
      {
        extend: 'print',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      },
      {
        extend: 'pdf',
        title: 'Pedido ' + $("#orderNumber").html() + ' Cliente ' + $("#prospect").html() + " " + 'asignado a ' + $("#user").html() + " " + $("#date").html() + " " + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      }
    ]
  });

  var tableThree = $('.dataTableNoPaginationNoButton').DataTable({
    "order": [[ 1, "asc" ]],
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
    dom: 'Bfrtip',
    buttons: [
    ]
  });

  var tableFour = $('.dataTableFour').DataTable({
    "order": [[ 1, "asc" ]],
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
      },
      {
        extend: 'pdfHtml5',
      },
    ]
  });

  var tableFive = $('.tableFive').DataTable({
    "order": [[ 1, "asc" ]],
    stateSave: true,
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
    dom: 'Bfrtip',
    buttons: [
      'pdfHtml5'
    ]
  });

  var tableSix = $('.tableSix').DataTable({
    "order": [[ 1, "asc" ]],
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
    dom: 'Bfrtip',
    buttons: [
      'pdfHtml5',
      {
        extend: 'print',
        title: $("#warehouseTitle").html(),
      },
    ]
  });

  var tableSeven = $('.tableSeven').DataTable({
    "order": [[ 1, "asc" ]],
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
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'print',
        orientation: 'landscape',
        title: "Programación de envíos " + $("#storeName").html() + " " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      },
      {
        extend: 'pdfHtml5',
        orientation: 'landscape',
        title: "Programación de envíos " + $("#storeName").html() + " " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      },
    ]
  });

  var tableEigth = $('.dataTableEight').DataTable({
    "order": [[ 1, "asc" ]],
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'print',
        orientation: 'landscape',
        title: "Historial de Pedidos entregados " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
      },
      {
        extend: 'pdfHtml5',
        orientation: 'landscape',
        title: "Historial de Pedidos entregados " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
      },
    ]
  });

  var tableNine = $('.dataTableNine').DataTable({
    "order": [[ 1, "asc" ]],
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'print',
        title: "Pedidos sin entregar " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        }
      },
      {
        extend: 'pdfHtml5',
        title: "Pedidos sin entregar " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
        }
      },
    ]
  });

  var tableTen = $('.dataTableTen').DataTable({
    "order": [[ 1, "asc" ]],
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'print',
        title: "Pedidos sin entregar " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      },
      {
        extend: 'pdfHtml5',
        title: "Pedidos sin entregar " + $("#dateToday").html() + " " + $("#hour").html() + " Hrs.",
        exportOptions: {
          columns: [0, 1, 2, 3, 4, 5, 6, 7]
        }
      },
    ]
  });

  var tableFour = $('.dataTableFourNoOrder').DataTable({
    "ordering": false,
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        orientation: 'landscape',
        title: "Ventas por tienda " + $("#date_month").html(),
      },
      {
        extend: 'pdfHtml5',
        orientation: 'landscape',
        pageSize: 'LEGAL',
        title: "Ventas por tienda " + $("#date_month").html(),
      },
    ]
  });

var tableFour = $('.dataTableFourNoOrderPortraitBillsReceived').DataTable({
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
  pageLength: 8,
  dom: 'Bfrtip',
  buttons: [
    {
      extend: 'excel',
      title: "Facturas recibidas del " + $("#initial_date").html() + ' ' + 'al ' + $("#final_date").html(),
    },
    {
      extend: 'pdfHtml5',
      title: "Facturas recibidas del " + $("#initial_date").html() + ' ' + 'al ' + $("#final_date").html(),
    },
  ]
});

var tableFour = $('.dataTableFourNoOrderPortraitBillsReceivedtwo').DataTable({
  "order": [[ 3, "asc" ]],
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
  pageLength: 8,
  dom: 'Bfrtip',
  buttons: [
    {
      extend: 'excel',
      title: "Facturas recibidas del " + $("#initial_date").html() + ' ' + 'al ' + $("#final_date").html(),
    },
    {
      extend: 'pdfHtml5',
      title: "Facturas recibidas del " + $("#initial_date").html() + ' ' + 'al ' + $("#final_date").html(),
    },
  ]
});

  var tableFour = $('.dataTableFourNoOrderPortrait').DataTable({
    "ordering": false,
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        title: "Ventas por tienda " + $("#date_month").html(),
      },
      {
        extend: 'pdfHtml5',
        title: "Ventas por tienda " + $("#date_month").html(),
      },
    ]
  });

  var tableFour = $('.dataTablestandard').DataTable({
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        orientation: 'landscape',
      },
      {
        extend: 'pdfHtml5',
        orientation: 'landscape',
      },
    ]
  });

  var tableFourClone = $('.dataTablestandardClone').DataTable({
    "order": [[ 1, "asc" ]],
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
    pageLength: 8,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        orientation: 'landscape',
      },
      {
        extend: 'pdfHtml5',
        orientation: 'landscape',
      },
    ]
  });

  $('.form-data-tables').on('submit', function(e){
    var $form = $(this);

    table.$('input[type="checkbox"]').each(function(){
      if(!$.contains(document, this)){
        if(this.checked){
          $form.append(
            $('<input>')
              .attr('type', 'hidden')
              .attr('name', this.name)
              .val(this.value)
            );
        }
      }
    });
  });

  $('.special-form-datatables').on('submit', function(e){
    var $form = $(this);

    tableTwo.$('input[type="checkbox"]').each(function(){
      if(!$.contains(document, this)){
        if(this.checked){
          $form.append(
            $('<input>')
              .attr('type', 'hidden')
              .attr('name', this.name)
              .val(this.value)
            );
        }
      }
    });

    tableTwo.$('input[type="text"]').each(function(){
      if(!$.contains(document, this)){
        $form.append(
          $('<input>')
            .attr('type', 'hidden')
            .attr('name', this.name)
            .val(this.value)
          );
      }
    });

  });

  $('.second-special-form-datatables').on('submit', function(e){
    var $form = $(this);

    tableTwoClone.$('input[type="checkbox"]').each(function(){
      if(!$.contains(document, this)){
        if(this.checked){
          $form.append(
            $('<input>')
              .attr('type', 'hidden')
              .attr('name', this.name)
              .val(this.value)
            );
        }
      }
    });

    tableTwoClone.$('input[type="text"]').each(function(){
      if(!$.contains(document, this)){
        $form.append(
          $('<input>')
            .attr('type', 'hidden')
            .attr('name', this.name)
            .val(this.value)
          );
      }
    });

  });

});
