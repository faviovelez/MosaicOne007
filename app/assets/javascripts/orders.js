$(function(){

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
    $.each($('input[id^=packetsProduct_product]'), function(){
      if ($(this).val() === ''){
        allFill = false;
        $(this).parent().addClass('has-error');
      } else {
        $(this).parent().removeClass('has-error').addClass('has-success');
      }
    });
    return allFill;
  };

  var checkUrgencyLevel = function(element){
    if ($(element).is(':checked')) {
      return 'alta';
    }
    return 'normal';
  };

  var createProductRequestData = function(){
    var data = {};
    $.each($('tr[id^=trForProduct]'), function(){
      data[$(this).attr('id')] = {
        id       : $(this).find('select').val(),
        packets  : $(this).find('input[id^=packetsProduct]').val(),
        order    : $(this).find('input[id^=orderProduct]').val(),
        total    : $(this).find('input[id^=totalProduct]').val(),
        urgency  : checkUrgencyLevel($(this).find('input[id^=urgencyProduct]')),
        maxDate  : $(this).find('input[id^=maxDateProduct]').val()
      };
    });
    return data;
  };

  $('#saveInfo').click(function(){
    var data = createProductRequestData();
    if (checkNotEmpty()){
      var re = /\d+/g;
      var storeId = document.location.href.match(re).pop();
      $.ajax({
        url: '/orders/save_products/'+ storeId,
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
        $(tr).find('td').slice(-11).remove();
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
        url: '/orders/get/' + $(element).val(),
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
            color:   response.product.exterior_color_or_design,
            inventory: response.inventory,
            pices:     response.product.pieces_per_package,
            price:     response.product.price,
            image:   image,
            link:    link,
            id:      id
          } )
        );

        $('#packetsProduct_'+ id)
          .mask("000000", {placeholder: "______"})
          .css({'text-align': 'center'})
          .blur(function(){
            var packets = parseInt($(this).val());
            var id = $(this).attr('id').replace('packetsProduct','');
            var pices = parseInt($('#pices' + id).html());
            $('#orderProduct' + id).val( packets * pices );
            var pedido = parseInt($('#orderProduct' + id).val());
            var price = $('#price' + id).data().price;
            $('#totalProduct' + id).val((price * 0.65 * pedido).toFixed(2));
          });

// En la línea anterior cambié la multiplicación del precio por un descuento fijo del 35%

        $('#urgencyProduct_' + id).click(function(){
          var element = $('#maxDate' + $(this).attr('id').replace('urgency', '')).parent();
          if ($(this).is(':checked')) {
            $(element).removeClass('hidden');
          } else {
            $(element).addClass('hidden');
          }
        });

        $('#addNew' + id).click(function(){

          // Código añadido para sumar //
          var result = 0;
          $.each($('input[id^=totalProduct]'), function(){
            result += parseFloat($(this).val());
          });
          $('#sumTotalOrder').html(result.toFixed(2));
          // Código añadido para sumar //

          var tr = "<tr id='trForProduct"+ inc +"'>" +
            "<td class='select'>" +
            "<select id='selectForProduct"+ inc +"'></select>" +
            "</td>" +
            "</tr>";
          $('tbody').prepend(tr);
          $('#selectForProduct'+ inc).append($('#trForProduct1 select').html());
          $('#selectForProduct'+ inc).select2({
            language: "es",
            templateSelection: formatState,
            multiple: true,
            maximumSelectionLength: 1,
            width: 200,
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

  var createJson = function(products){
    return _.map(products, function(product){
      return {
        text: product.shift(),
        id  : product.shift()
      };
    });
  };

  if ($('#product1').length > 0) {
    setTimeout(function(){
      $('#product1').select2({
        language: "es",
        templateSelection: formatState,
        multiple: true,
        width: 200,
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
    }, 200);
  }

});
