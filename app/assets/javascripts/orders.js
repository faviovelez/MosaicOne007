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

  var createProductRequestData = function(){
    var data = {};
    $.each($('tr[id^=trForProduct]'), function(){
      data[$(this).attr('id')] = {
        id       : $(this).find('select').val(),
        cantidad : $(this).find('input[id^=numProduct]').val()
      };
      var index = $(this).attr('id').match(/\d+/)[0];
      if (supplier) {
        data[$(this).attr('id')].supplierInfo = $('#supplierInfoproduct' + index).html();
      }
    });
    return data;
  };

  $('#saveInfo').click(function(){
    var data = createProductData();
    if (checkNotEmpty()){
      $.ajax({
        url: '/orders/save_products',
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
        url: '/orders/get/' + $(element).val(),
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
            color:   response.product.exterior_color_or_design,
            inventory: response.inventory,
            pices:     response.product.pieces_per_package,
            price:     response.product.price,
            image:   image,
            link:    link,
            id:      id
          } )
        );

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
    }, 200);
  }

});
