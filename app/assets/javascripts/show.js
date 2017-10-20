var counter = 0;
$(".confirm").ready(function() {
  $("#show").click(function () {
    event.preventDefault();
    if (counter == 0) {
      $("#information").removeClass('hidden');
      counter +=1;
      $("#show").text('Ocultar detalles');
    } else if (counter > 0) {
      $("#information").addClass('hidden');
      counter -=1;
      $("#show").text('Mostrar detalles');
    };
  });
});
