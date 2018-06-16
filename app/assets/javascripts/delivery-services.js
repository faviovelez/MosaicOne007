$(document).ready(function(){
  $('table.table-display').DataTable({
    "order": [[ 0, "asc" ]],
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
    pageLength: 5,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        orientation: 'landscape',
        title: 'Base de datos de mensajerías:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs'
      },
      {
        extend: 'pdf',
        orientation: 'landscape',
        pageSize: 'LEGAL',
        title: 'Base de datos de mensajerías:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]
        },
      },
    ]
  });

  $('table.table-display-details').DataTable({
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
    pageLength: 5,
    dom: 'Bfrtip',
    buttons: [
      {
        extend: 'excel',
        title: 'Reporte de ventas mensajerías:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        },
      },
      {
        extend: 'pdf',
        orientation: 'landscape',
        title: 'Reporte de ventas de mensajerías:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs',
        exportOptions: {
          columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        },
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

});
