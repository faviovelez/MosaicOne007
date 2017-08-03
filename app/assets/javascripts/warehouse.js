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
        $('.image-temp').remove();
        var newLink = $('#link_to_images').attr('href').replace(/[0-100]/g, response.product.id);
        $('#link_to_images').attr('href', newLink.replace('root','warehouse-new_own_entry'));
        $('#link_to_images').append('<img class="image-temp" src="' + image + '">');
      }
    });
  });

});
