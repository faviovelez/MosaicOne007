$(function(){
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g,
    variable: 'rc'
  };

  $('#movement_product_id').select2({
    maximumSelectionLength: 1,
    multiple: true
  })
  .change(function(){
    if ($(this).val() === null) {
      $('#product_1').remove();
    } else {
      $.ajax({
        url: '/warehouse/get/' + $(this).val(),
        method: 'get'
      }).done(function(response) {
        var template = _.template(
          $( "script.template" ).html()
        );
        var image = response.images.length > 0 ?
          response.images[0].image.small.url :
          $('#not_image_temp').attr('src');
        var link = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
        var id = "product_" + $('select').length;
        var input = '<a href="#" id="newProduct" class="btn btn-default productInfoData">Agregar nuevo</a>';
        $('#new_movement').append(
          template( {
            unique_code: response.product.unique_code,
            description: response.product.description,
            image:       image,
            link:        link,
            id:          id
          } )
        );
        if ($('#newProduct').length === 0){
          $('#new_movement').append(input);
        }
        $('#newProduct').click(function(){
          var inc = ($('select').length + 1);
          var id = 'select_product_' + inc;
          var label = '<label for="' + id + '">Selecionar producto</label><br />';
          var select = '<select id="' + id  + '"></select><br />';
          $('#new_movement').append(label).append(select);
          $('#' + id)
          .append($('#movement_product_id').html())
          .select2({
            maximumSelectionLength: 1,
            multiple: true
          })
          .change(function(){
            var inc = ($('select').length);
            if ($(this).val() === null) {
              $('#product_' + inc).remove();
            } else {
              $.ajax({
                url: '/warehouse/get/' + $(this).val(),
                method: 'get'
              }).done(function(response) {
                var template = _.template(
                  $( "script.template" ).html()
                );
                var image = response.images.length > 0 ?
                  response.images[0].image.small.url :
                  $('#not_image_temp').attr('src');
                var link = $('#link_to_images').attr('href').replace(/\d+/g, response.product.id);
                var id = "product_" + $('select').length;
                $('#new_movement').append(
                  template( {
                    unique_code: response.product.unique_code,
                    description: response.product.description,
                    image:       image,
                    link:        link,
                    id:          id
                  } )
                );
              });
            }
          });
          $('#newProduct').appendTo('#new_movement');
          return false;
        });
      });
    }
  });

});
