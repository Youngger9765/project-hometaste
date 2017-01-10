(function() {
  $(document).ready(function() {
    var update_spinner_input;
    update_spinner_input = function(command) {
      var max, min, num, product_item_input, step, val;
      min = 0;
      max = 500;
      step = 1;
      product_item_input = $(this).closest('.product_item').find('#txtNum');
      val = product_item_input.val().trim();
      num = val !== '' ? parseInt(val) : 0;
      switch (command) {
        case 'Up':
          if (num < max) {
            num += step;
            break;
          }
          break;
        case 'Down':
          if (num > min) {
            num -= step;
            break;
          }
      }
      return product_item_input.val(num);
    };
    return $(document).on('click', '.product_spineer_button', function() {
      var command;
      command = $(this).attr('command');
      return update_spinner_input.bind(this)(command);
    });
  });

}).call(this);
