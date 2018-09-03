$(document).ready(function(){

  $('#store_list').select2({
     placeholder: 'Tiendas',
     language: "es"
  });

  $('#month_and_year').select2({
     placeholder: 'Mes y año',
     language: "es",
     maximumSelectionLength: 1
  });

  $("#report_type").bind('change', function() {
    var reportType = $(this).val();
    if (reportType == 'Facturación por empresa' || reportType == 'Pagos por empresa' || reportType == 'Saldo por clientes' || reportType == 'Facturas recibidas') {
      $(".month-list").addClass('hidden');
      $(".store-options").addClass('hidden');
      $(".date-options").removeClass('hidden');
      $(".companies-list").removeClass('hidden');
      if ($("#options").val() == 'Seleccionar día') {
        $(".group_fields").addClass("hidden");
        $(".extra-margin-top").removeClass("hidden");
      } else if ($("#options").val() == 'Mes actual') {
        $(".group_fields").addClass("hidden");
        $(".extra-margin-top").addClass("hidden");
      } else {
        $(".group_fields").removeClass("hidden");
        $(".extra-margin-top").addClass("hidden");
      }
      $(".group-options").addClass("hidden");
    } else if (reportType == 'Compras por tienda por mes') {
      $(".group-options").removeClass("hidden");
      $(".companies-list").addClass('hidden');
      $(".date-options").addClass('hidden');
      $(".single-date").addClass('hidden');
      $(".group_fields").addClass("hidden");
    } else {
      if (reportType == 'Comparativo compras por mes') {
        $(".group_options").removeClass('hidden');
        $(".store-options").addClass('hidden');
      } else {
        $(".group_options").addClass('hidden');
        $(".store-options").removeClass('hidden');
      }
      $(".select2.select2-container").addClass("width-200");
      $(".companies-list").addClass('hidden');
      $(".month-list").removeClass('hidden');
      $(".store-options").removeClass('hidden');
      $(".date-options").addClass('hidden');
      $(".single-date").addClass('hidden');
      $(".group_fields").addClass("hidden");
      $(".group-options").addClass("hidden");
    }
  });

  $("#group_options").bind('change', function() {
    var groupType = $(this).val();
    if (groupType == 'Solo tiendas' || groupType == 'Solo franquicias' || groupType == 'Solo distribuidores') {
      $(".client-list").addClass("hidden");
    } else {
      $(".select2.select2-container").addClass("width-450");
      $(".client-list").removeClass("hidden");
    }
  });

  $("#store_options").bind('change', function() {
    var storeOptions = $(this).val();
    if (storeOptions == 'Seleccionar tiendas') {
      $(".select2.select2-container").addClass("width-200");
      $('.store-list').removeClass('hidden');
    } else {
      $('.store-list').addClass('hidden');
    }
  });

});
