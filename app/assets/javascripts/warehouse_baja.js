$(function(){
  var findInSelect = function(findCode, id){
    var find = false;
    $.each($('select.isSelect2'), function(){
      if ($(this).val().toString() === findCode.toString() && $(this).attr('id') !== id){
        find = true;
        return true;
      }
    });
    return find;
  };

  var checkValidations = function(){
    var hasError = true;
    $.each($('input[id^=numProduct_product]'), function(){
      var index = $(this).attr('id').replace(/\D/g,'');
      var actual_inventory = parseInt($('#inventory_product' + index).html());
      if ($(this).val() === '' || parseInt($(this).val()) > actual_inventory ){
        hasError = false;
        $(this).parent().addClass('has-error');
      } else {
        $(this).parent().removeClass('has-error').addClass('has-success');
      }
    });
    return hasError;
  };

  var createProductData = function(supplier){
    var data = {};
    $.each($('tr[id^=trForProduct]'), function(){
      data[$(this).attr('id')] = {
        id       : $(this).find('select:first').val(),
        cantidad : $(this).find('input[id^=numProduct]').val(),
        reason   : $(this).find('select:last').val()
      };
      var index = $(this).attr('id').match(/\d+/)[0];
      if (supplier) {
        data[$(this).attr('id')].supplierInfo = $('#supplierInfoproduct' + index).html();
      }
    });
    return data;
  };

  $('#sendInfo').click(function(){
    var data = createProductData(false);
    if (checkValidations()){
      $.ajax({
        url: '/warehouse/remove_product',
        data: data,
        method: 'post'
      });
    }
    return false;
  });

  var changeAction = function(element, inc, dec){
    if ($(element).val() === null) {
      var tr = $('td[id$=product'+dec+']').parent();
      var selectId = $(tr).find('select').attr('id');
      if ($('tbody tr').length > 1) {
        $('#' + selectId).select2('destroy');
        $(tr).remove();
      } else {
        if ($('#suppliersList')) {
          $(tr).find('td').slice(-5).remove();
        }
        else {
          $(tr).find('td').slice(-4).remove();
        }
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
          response.images[0].image.thumb.url :
          $('#not_image_temp').attr('src');
        var link = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
        var id = "product" + dec;
        $('#trForProduct' + dec).append(
          template( {
            description: response.product.description,
            inventory:   response.inventory,
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

        $('#numProduct_'+ id).mask("000000000000000", {placeholder: "_______________"}).css({'text-align': 'center'});
        $('#addNew' + id).click(function(){
          var tr = "<tr id='trForProduct"+ inc +"'>" +
            "<td class='select'>" +
            "<select id='selectForProduct"+ inc +"'></select>" +
            "</td>" +
            "</tr>";
          $('tbody').prepend(tr);
          $('#selectForProduct'+ inc).append($('#trForProduct1 select').html());
          $('#selectForProduct'+ inc)
            .addClass('isSelect2')
            .select2({
              templateSelection: formatState,
              language: "es",
              multiple: true,
              maximumSelectionLength: 1,
              width: 300,
              ajax: {
                url: '/api/get_all_products',
                method: 'POST',
                dataType: 'json',
                delay: 250,
                processResults: function (data) {
                  return {
                    results: createJson(data.products)
                  };
                },
                cache: true
              }
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

  var createJson = function(products){
    return _.map(products, function(product){
      return {
        text: product.shift(),
        id  : product.shift()
      };
    });
  };

  $('#product1').select2({
    language: "es",
    templateSelection: formatState,
    multiple: true,
    width: 300,
    maximumSelectionLength: 1,
    ajax: {
      url: '/api/get_all_products',
      method: 'POST',
      dataType: 'json',
      delay: 250,
      processResults: function (data) {
        return {
          results: createJson(data.products)
        };
      },
      cache: true
    }
  })
    .change(function(){
      changeAction(this, 2, 1);
    });
  $(".se-pre-con").fadeOut("slow");
});
