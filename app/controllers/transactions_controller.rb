class TransactionsController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => :create

	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
	Braintree::Configuration.public_key = "n3tn23y52b346z3x"
	Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

  def new
  	@client_token = Braintree::ClientToken.generate
  end

  def create
  	nonce_from_the_client = params["payment-method-nonce"]
  	result = Braintree::Transaction.sale(
		  :amount => "10.00",
		  :payment_method_nonce => nonce_from_the_client,
		  :options => {
		    :submit_for_settlement => true
		  }
		)

		raise
  end
end
