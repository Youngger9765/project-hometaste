class OrdersController < ApplicationController

	skip_before_filter :verify_authenticity_token
	before_action :find_order, :except => [:new,:create]

	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
	Braintree::Configuration.public_key = "n3tn23y52b346z3x"
	Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

	def new
		@order = Order.new
	end

	def create

		@order = current_user.orders.new(orders_params)
		@order.pick_up_datetime = pick_datetime
		@order.customer_name = current_user.name
		@order.payment_status = 'unpaid'
		@order.order_status = 'not yet'

		if @order.save
			create_user_bigbun(params[:bigbun])
			create_user_order_food(params[:food])
			@order.update_order_price

			flash[:notice] = "Successfully create order!"
			redirect_to @order
		else
			flash.now[:notice] = "Fail new order!"
			render 'new'
		end

	end

	def show
		@client_token = Braintree::ClientToken.generate
		if request.env["HTTP_REFERER"]
			@clean_cart_cookie = request.env["HTTP_REFERER"].match(/orders\/new/) ? true : false
		end

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
			# TODO: update order
			@order.payment_status = "paid"
			@order.confirmation_number = result.transaction.id
			@order.save!

			flash[:notice] = "Successfully paid!"
			@thankyou = true
			redirect_to order_path(@order.id)
		else
			render :show
		end

	end

	private

	def find_order
		@order = Order.find(params[:id])
	end

	def orders_params
		params.require(:order).permit(:shipping_method, :shipping_place, :tip ,:restaurant_id )
	end

	def pick_datetime
		(params[:pick_up_date] +" "+ params[:pick_up_time]).to_datetime
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
			params.each do |key,value|
				@order.order_food_ships.find_or_create_by( food_id: key.to_i,quantity: value.to_i)
			end
		end
	end

end
