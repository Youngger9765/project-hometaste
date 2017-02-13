class OrdersController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_action :find_order, :except => [:new,:create]
  before_action :find_restaurant
  before_action :is_chef?

  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
  Braintree::Configuration.public_key = "n3tn23y52b346z3x"
  Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

  def new
    @order = Order.new
    @restaurant = Restaurant.find(params[:restaurant_id])

    order_date = params[:date].to_date
    date_now = Time.now.localtime.to_date

    if order_date == date_now
      # check cut off time
      # time_now = Time.now.localtime
      time_now = Time.now.at_beginning_of_day
      @pick_up_time_array = []
      @time_location_dictionary = []

      @restaurant.bulk_buys.each do |bulk_buy|

        if bulk_buy.pick_up_time_1.present?
          pick_up_time = bulk_buy.pick_up_time_1.localtime.strftime("%H:%M:%S").to_time

          if pick_up_time > time_now

            if pick_up_time > time_now
              @pick_up_time_array << bulk_buy.pick_up_time_1.localtime.strftime("%H:%M:%S")
              dict = {}
              dict[:pick_up_time] = bulk_buy.pick_up_time_1.localtime.strftime("%H:%M:%S")
              dict[:location] = bulk_buy.location_1
              @time_location_dictionary << dict
            end
          end
        end

        if bulk_buy.pick_up_time_2.present?
          pick_up_time = bulk_buy.pick_up_time_2.localtime.strftime("%H:%M:%S").to_time

          if pick_up_time > time_now
            @pick_up_time_array << bulk_buy.pick_up_time_2.localtime.strftime("%H:%M:%S")
            dict = {}
            dict[:pick_up_time] = bulk_buy.pick_up_time_2.localtime.strftime("%H:%M:%S")
            dict[:location] = bulk_buy.location_1
            @time_location_dictionary << dict
          end
        end
      end

    else
      # give all pick_up_time
      bulk_buys = @restaurant.bulk_buys
      @pick_up_time_array = []
      @time_location_dictionary = []

      bulk_buys.each do |bulk_buy|

        # time_1
        if bulk_buy.pick_up_time_1
          @pick_up_time_array << bulk_buy.pick_up_time_1.localtime.strftime("%H:%M:%S")
          dict = {}
          dict[:pick_up_time] = bulk_buy.pick_up_time_1.localtime.strftime("%H:%M:%S")
          dict[:location] = bulk_buy.location_1
          @time_location_dictionary << dict
        end

        # time_2
        if bulk_buy.pick_up_time_2
          @pick_up_time_array << bulk_buy.pick_up_time_2.localtime.strftime("%H:%M:%S")
          dict = {}
          dict[:pick_up_time] = bulk_buy.pick_up_time_2.localtime.strftime("%H:%M:%S")
          dict[:location] = bulk_buy.location_2
          @time_location_dictionary << dict
        end
      end
    end

  end

  def create
    @order = current_user.orders.new(orders_params)
    @order.pick_up_time = get_pick_up_time
    @order.customer_name = current_user.name
    @order.payment_status = 'unpaid'
    @order.order_status = 'process'
    flash[:alert] = []

    @error = false
    # check delivery order_min
    if orders_params[:shipping_method] == "delivery"
      check_delivery_min_order(params[:food])
    end

    if !@error && @order.save
      # create_user_bigbun(params[:bigbun])
      cookies.delete(:cart_list, path: '/')

      flash[:notice] = "Successfully create order!"
      redirect_to restaurant_order_path(@restaurant,@order)
    else
      flash[:alert] << "Fail new order!"
      render 'new'
    end

  end

  def show
    @client_token = Braintree::ClientToken.generate

    case @order.payment_status
    when 'unpaid' ;@thankyou = false
    when 'paid' ;@thankyou = true
    end

  end

  def transactions

    nonce_from_the_client = params["payment-method-nonce"]
    result = Braintree::Transaction.sale(
      :amount => @order.amount,
      :payment_method_nonce => nonce_from_the_client,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success?
      @order.update(orders_params)
      @order.payment_status = "paid"
      @order.confirmation_number = result.transaction.id
      @order.save!

      flash[:notice] = "Successfully paid!"
      @thankyou = true
      redirect_to restaurant_order_path(@restaurant.id,@order.id)
    else
      render :show
    end

  end

  private

  def get_restaurant_from_cookies
    if cookies[:cart_list]
      cart = JSON.parse(cookies[:cart_list])
      keys = cart.keys.select do |key|
        cart[key].keys.select { |x| x.match(/food_\d/) }
      end
      id = keys.last.gsub('restaurant_','')
      Restaurant.find(id)
    end
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def orders_params
    params.require(:order).permit(:shipping_method, :shipping_place,:restaurant_id,
                                  :mobile_number, :email, :billing_address, :pick_up_time,
                                  :billing_city, :billing_state, :billing_zip_code,
                                  order_food_ships_attributes: [
                                                                 :food_id, :quantity
                                                               ])
  end

  def get_pick_up_time
    # Save to utc
    (params[:date] + ' ' + params[:order][:pick_up_time]).to_time.utc
  end

  def create_user_bigbun(params)
    if params
      params.each do |key|
        current_user.user_big_bun_ships.find_or_create_by(order_id: @order.id, big_bun_id: key.to_i)
      end
    end
  end

  def create_user_order_food(params)
    if params
      params.each do |key, value|
        @order.order_food_ships.find_or_create_by(food_id: key.to_i, quantity: value.to_i)
      end
    end
  end

  def is_chef?
    if current_user && current_user.is_chef
      flash[:alert] = "Chef can't build order!"
      redirect_to root_path
    else
      return true
    end
  end

  def check_delivery_min_order(foods_hash)
    restaurant = Restaurant.find(orders_params[:restaurant_id])
    min_order = restaurant.delivery.min_order

    total_amount = 0

    foods_hash.each do |key,value|
      food_price = Food.find(key).price
      quantity = value.to_f
      amount = food_price*quantity
      total_amount += amount
    end

    if total_amount < min_order
      @error = true
      flash[:alert] << "your oreder amount is under delivery min_order"
    end
  end

end
