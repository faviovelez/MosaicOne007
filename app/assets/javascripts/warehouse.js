$(function(){
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g,
    variable: 'rc'
  };

  var formatState = function(state){
    var r = /\d+/;
    var code = state.text.match(r);
    return code;
  };

  var changeAction = function(element, inc, dec){
    if ($(element).val() === null) {
      $('td[id$=product'+dec+']').remove();
    } else {
      $.ajax({
        url: '/warehouse/get/' + $(element).val(),
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
            description: response.product.description,
            image:       image,
            link:        link,
            id:          id
          } )
        );
        $('#numProduct_'+ id).mask("000", {placeholder: "___"}).css({'text-align': 'center'});
        if ($('tr[id^=trForProduct]').length === dec){
          $('#addNew' + id).click(function(){
            var tr = "<tr id='trForProduct"+ inc +"'>" +
              "<td class='select'>" +
              "<select id='selectForProduct"+ inc +"'></select>" +
              "<a href='#' class='btn btn-danger hidden'>X</a>" +
              "</td>" +
              "</tr>";
            $('tbody').append(tr);
            $('#selectForProduct'+ inc).append($('#product1').html());
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
        } else {
          $('#addNew' + id).addClass('hidden');
        }
      });
    }
  };

  $('#product1').select2({
    templateSelection: formatState,
    multiple: true,
    maximumSelectionLength: 1
  })
  .change(function(){
    changeAction(this, 2, 1);
  });

});
