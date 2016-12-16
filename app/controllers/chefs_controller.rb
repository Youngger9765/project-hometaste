class ChefsController < ApplicationController

	def new
		@user = User.new
		@chef = Chef.new
	end

	def create
		raise
	end

	private

	def chef_params
	  params.require(:chef).permit(
	  	:first_name, :last_name, :phone_number, :birthday,
	  	:SSN, :routing_number, :account_number,

	  	:restaurant_attributes => [
	  		:id, :name, :address, :phone_number,:description,
	  		:city, :state, :ZIP, :tax_ID, :communication_method,
	  	]
	  )
	end
end
