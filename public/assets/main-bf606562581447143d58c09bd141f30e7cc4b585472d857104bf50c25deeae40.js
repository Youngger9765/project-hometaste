(function() {
  $(document).ready(function() {
    var cards_num, cards_qty, check_checkbox_status, filter_ajax, get_cards_id, load_more_times, modify_card_column, render_food_card, render_google_map;
    $('.ui.rating').rating('disable');
    modify_card_column = function() {
      $('.cards .col-xs-6:odd').addClass('padding_left_7_xs');
      $('.cards .col-xs-6:even').addClass('padding_right_7_xs');
      return $('.card').each(function(index) {
        var button, popup;
        button = $(this).find('.custom.button');
        popup = $(this).find('.custom.popup');
        button.popup({
          popup: popup,
          position: 'top right',
          hoverable: true
        });
        $(this).hover(function() {
          return $(this).find('.card_hover_link').toggleClass('hidden');
        });
        if ((index + 1) % 2 === 0) {
          $(this).parent().after("<div class='clearfix visible-sm visible-xs'></div>");
        }
        if ((index + 1) % 3 === 0) {
          return $(this).parent().after("<div class='clearfix hidden-sm hidden-xs'></div>");
        }
      });
    };
    modify_card_column();
    load_more_times = 1;
    cards_qty = 9;
    cards_num = function() {
      if ($(window).width() < 992) {
        cards_qty = 8;
      }
      return cards_qty;
    };
    render_food_card = function(num) {
      var card;
      card = $('.card:lt(' + num + ')');
      card.addClass('visible');
      return $('.card:lt(' + num + ') img').each(function() {
        return $(this).attr('src', $(this).attr("data-src"));
      });
    };
    render_food_card(cards_num());
    $(window).resize(function() {
      cards_num();
      return render_food_card(cards_num() * load_more_times);
    });
    $('#load_more').click(function() {
      load_more_times += 1;
      cards_num();
      return render_food_card(cards_num() * load_more_times);
    });
    $('p[name="more_cuisine"]').click(function() {
      return $('.ui.modal[name="more_cuisine"]').modal('show');
    });
    $(document).on('click', '.foods div[data-tooltip="Address"]', function(e) {
      $(this).parents('.content').find('.address_detail').toggleClass('hidden');
      $(this).find('i').toggleClass('black');
      return e.preventDefault();
    });
    $('div[data-tooltip="Map view"],div[data-tooltip="Product list"]').click(function() {
      $('div[data-tooltip="Product list"],div[data-tooltip="Map view"]').toggleClass('hidden');
      $('.foods.cards , .location_map').toggleClass('hidden');
      if ($(this).data('tooltip') === 'Map view') {
        return render_google_map();
      }
    });
    get_cards_id = function() {
      var ids, qty;
      ids = [];
      qty = -cards_qty - 1;
      $(".card.visible:gt(" + qty + ")").each(function() {
        return ids.push($(this).data('id'));
      });
      return ids;
    };
    render_google_map = function() {
      return $.ajax({
        type: 'GET',
        url: '/api/v1/getDishesByFilter',
        data: {
          ids: get_cards_id()
        },
        success: function(data) {
          return buildMap(data.gmap_hash);
        }
      });
    };
    $('.menu .item').mouseover(function() {
      return $('#keyword_input').val($(this).html());
    });
    $('#search_submit').click(function() {
      var keyword, location;
      keyword = $('#keyword_input').val();
      location = $('#location_input').val();
      return $.ajax({
        type: 'GET',
        url: '/api/v1/search/keyword',
        data: {
          keyword: keyword,
          location: location
        },
        complete: function() {
          modify_card_column();
          return render_food_card(cards_num());
        }
      });
    });
    filter_ajax = function() {
      var checked_list, checked_list_name;
      checked_list_name = {};
      checked_list = $(':checked').siblings('label');
      $.each(checked_list, function() {
        var p_html;
        p_html = $(this).closest('.grouped').siblings('p').html();
        if (checked_list_name["" + p_html] === void 0) {
          checked_list_name["" + p_html] = [];
        }
        return checked_list_name["" + p_html].push($(this).html());
      });
      return $.ajax({
        type: 'GET',
        url: '/api/v1/search/filter',
        data: {
          checked_list: checked_list_name
        }
      });
    };
    check_checkbox_status = function() {
      if (($(this).attr('id') === 'any_cuisine') && ($('#any_cuisine input').prop('checked') === true)) {
        return $('.cuisine_grouped .ui.checkbox:not(#any_cuisine)').checkbox('uncheck');
      } else if ($(this).attr('id') !== 'any_cuisine') {
        return $('#any_cuisine').checkbox('uncheck');
      }
    };
    $('.cuisine_grouped .ui.checkbox').click(function() {
      return check_checkbox_status.bind(this)();
    });
    $('.distance_input').on('change', function() {
      return $(this).find('label').html($(this).find('#distance_input').val());
    });
    $('.distance_input').focusout(function() {
      return filter_ajax();
    });
    $('.distance_input').keypress(function(event) {
      if (event.which === 13) {
        filter_ajax();
        return $(this).find('input').blur();
      }
    });
    $('.filter_menu .ui.checkbox:not(.distance_input)').change(function() {
      return filter_ajax();
    });
    return $('#cuisine_modal_btn').click(function() {
      filter_ajax();
      return $('.ui.small.modal').modal('hide');
    });
  });

}).call(this);
