$(document).ready ->
  update_spinner_input=(command) ->
    min = 0
    max = 500
    step = 1
    product_item_input = $(this).closest('.product_item').find('#txtNum')
    val = product_item_input.val().trim();
    num = if val isnt '' then parseInt(val) else 0
    switch command
      when 'Up'
        if (num < max)
          num += step
          break
      when 'Down'
        if (num > min)
          num -= step
          break
    product_item_input.val(num)

  $(document).on 'click','.product_spineer_button', ->
    command = $(this).attr('command')
    update_spinner_input.bind(this)(command)
