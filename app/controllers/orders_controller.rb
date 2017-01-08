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

    if @order.payment_status == "unpaid"
      @thankyou = false
    else
      @thankyou = true
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

end
