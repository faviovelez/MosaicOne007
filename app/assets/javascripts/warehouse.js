$(function(){
  $('#movement_product_id').select2({
    width: '300',
    placeholder: "Selectione un cliente",
    allowClear: true
  })
  .unbind('change')
  .change(function(){
    $.ajax({
      url: '/warehouse/get/' + $(this).val(),
      method: 'get'
    }).done(function(response) {
      if (response.product) {
        var image = response.images.length ?
          response.images[0].image.small.url :
          $('#not_image_temp').attr('src');
        $('.image-temp, .productInfoData').remove();
        var newLink = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
        $('#link_to_images').attr('href', newLink.replace('root','warehouse-new_own_entry'));
        $('#link_to_images').append('<img class="image-temp" src="' + image + '">');
        var codigo = '<p class="productInfoData"><span><strong>Código: </strong>' + response.product.unique_code  + '</span></p>';
        var description = '<p class="productInfoData"><span><strong>Descripcion: </strong>' + response.product.description  + '</span></p';
        var input = '<label class="productInfoData" for="numPices">Numero de piezas</label><div class="field">' +
                      '<input class="productInfoData" id="numPices" type="text" value="" placeholder="Piezas a dar de Alta" />' +
                    '</div>';
        $('#productInfo').append(codigo).append(description).append(input);
        $('#numPices').mask('000', {placeholder: "___"}).css({'text-align': 'center'});
        input = '<a href="#" id="newProduct" class="btn btn-default productInfoData">Agregar nuevo</a>';
        $('#productInfo').append(input);
        $('#newProduct').click(function(){
          var inc = ($('select').length + 1);
          var id = 'product_' + inc;
          var label = '<label for="' + id + '">Selecionar producto</label><br />';
          var select = '<select id="' + id  + '"></select>';
          $('#new_movement').append(label).append(select);
          $('#' + id)
          .append($('#movement_product_id').html())
          .select2({
            width: '300',
            placeholder: "Selectione un cliente",
            allowClear: true
          })
          .unbind('change')
          .change(function(){
            $.ajax({
              url: '/warehouse/get/' + $(this).val(),
              method: 'get'
            }).done(function(response) {
              var newLink = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
              $('#product' + inc + ', .productInfoData' + inc + ', #numPices' + inc).remove();
              var image = '<br /><img class="image-temp-'+ inc +'" id="not_image_temp_'+ inc +'" src="'+ $('#not_image_temp').attr('src') +'" alt="Product small">';
              var link = '<a id="product'+ inc +'" href="'+ newLink  +'">'+ image +'</a>';
              $('#new_movement').append(link);
              var codigo = '<p class="productInfoData'+inc+'"><span><strong>Código: </strong>' + response.product.unique_code  + '</span></p>';
              var description = '<p class="productInfoData'+inc+'"><span><strong>Descripcion: </strong>' + response.product.description  + '</span></p';
              var input = '<label class="productInfoData'+inc+'" for="numPices'+inc+'">Numero de piezas</label>' + '<input class="productInfoData" id="numPices'+inc+'" type="text" value="" placeholder="Piezas a dar de Alta" />';
              $('#new_movement').append(codigo).append(description).append(input);
              $('#numPices' + inc).mask('000', {placeholder: "___"}).css({'text-align': 'center'});
              $('#new_movement').append('<br />');
              $('#newProduct').appendTo('#new_movement');
            });
          });
          return false;
        });
      }
    });
  });

});
