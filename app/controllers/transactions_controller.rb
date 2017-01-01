class TransactionsController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => :create
	before_action :find_restaurant
	before_action :create_cart, :only => :new
	before_action :create_cart_foods, :only => :new
	before_action :create_cart_bigbuns, :only => :new

	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
	Braintree::Configuration.public_key = "n3tn23y52b346z3x"
	Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

  def new
  	@client_token = Braintree::ClientToken.generate
  end

  def create
  	@cart = current_user.carts.where(:restaurant_id => @restaurant.id).first

  	nonce_from_the_client = params["payment-method-nonce"]
  	result = Braintree::Transaction.sale(
		  :amount => @cart.total_amount,
		  :payment_method_nonce => nonce_from_the_client,
		  :options => {
		    :submit_for_settlement => true
		  }
		)

  	if result.success?
  		# TODO: create order, order_food_ships

  		# TODO: destroy cart
  	else
  		render :new
  	end

  end

  private

  def find_restaurant
  	@restaurant = Restaurant.find(params[:restaurant_id])
  end

  def create_cart
  	@cart = current_user.carts.where(:restaurant_id => @restaurant.id).first || current_user.carts.create(:restaurant_id => @restaurant.id)
  	
  	# FAKE
  	@cart.delivery_fee = rand(0..3)
  	@cart.tip = rand(0..3)
  	@cart.tax = rand(0..3)
  	@cart.total_amount = @cart.delivery_fee + @cart.tax + @cart.tip + @cart.sub_total
  	@cart.save!
  end

  def create_cart_foods
  	# TODO: base on data transfered from frontend
  	# FAKE
  	@cart.cart_foods.destroy_all
  	num = rand(1..5)
  	for food in @restaurant.foods
  		food_id = food.id
  		food_price = food.price
  		quantity = rand(0..5)
  		if quantity > 0
  			cart_food = @cart.cart_foods.create(
	  			:food_id => food_id,
	  			:quantity => quantity,
	  			:price => food_price,
	  			:sub_total => quantity*food_price,
	  		)
  		end

  		if @cart.cart_foods.size > num
  			break
  		end
  	end

  	@cart.sub_total = @cart.cart_foods.sum(:sub_total)
  	@cart.save!
  end

  def create_cart_bigbuns
  	
  end

end
