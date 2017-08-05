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
        $('#new_movement').after(
          template( {
            unique_code: response.product.unique_code,
            description: response.product.description,
            image:       image,
            link:        link,
            id:          "product_" + $('select').length
          } )
        );
      });
    }
  });

});
