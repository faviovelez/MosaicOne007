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
