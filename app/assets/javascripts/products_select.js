$(document).ready(function(){

  $('.select2-sat-keys').select2({
     placeholder: 'Código SAT',
     tags: true,
     maximumSelectionLength: 1,
     language: "es"
  });

  $('.select2-sat-unit-keys').select2({
     placeholder: 'Unidad SAT',
     tags: true,
     maximumSelectionLength: 1,
     language: "es"
  });

});
