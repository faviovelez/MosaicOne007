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
        title: 'Resumen de ventas:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs'
      },
      {
        extend: 'pdf',
        title: 'Resumen de ventas:' + $("#date").html() + $("#store").html() + $("#hour").html() + 'hrs'
      },
    ]
  });

  $('#payment-day').DataTable({
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
    pageLength: 6,
    responsive: true,
    dom: 'Bfrtip',
    buttons: [
        {
            extend: 'pdfHtml5',
            text: 'Save current page',
            exportOptions: {
                modifier: {
                    page: 'current'
                }
            }
        }
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
