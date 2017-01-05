class OrdersController < ApplicationController

	skip_before_filter :verify_authenticity_token
	before_action :find_order, :except => [:new]

	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
	Braintree::Configuration.public_key = "n3tn23y52b346z3x"
	Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

  def new
  end

  def show
  	@client_token = Braintree::ClientToken.generate
  end

  def transactions

  	nonce_from_the_client = params["payment-method-nonce"]
  	result = Braintree::Transaction.sale(
		  :amount => 10,
		  :payment_method_nonce => nonce_from_the_client,
		  :options => {
		    :submit_for_settlement => true
		  }
		)

  	if result.success?
  		# TODO: update order
  		@order.payment_status = "paid"
  		# TODO: destroy cart
  	else
  		render :show
  	end

  end

  private

  def find_order
  	@order = Order.find(params[:id])
  end

end
