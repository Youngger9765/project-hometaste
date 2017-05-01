$(document).ready ->

  $(document).click (e) ->
    close_modal(e)

  close_modal = (e) ->
    target = e.target;
    if $('.message_content:visible').length > 0
      if $(target).is('.fa.fa-angle-left') || $(target).is('.message_close') || !$(target).parents('.message_modal').is('.message_modal')
        $('.message_modal').hide();
        $('.message_close').hide();
#    else if ( $(target).is('.fa.fa-angle-left') || $(target).is('.message_close') || !$(target).is('[name="message_button"]') && !$(target).is('.message_modal') && !$(target).parents('.message_modal').is('.message_modal'))
#        $('.message_modal').hide();
#        $('.message_close').hide();
