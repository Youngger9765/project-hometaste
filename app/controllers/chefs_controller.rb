class ChefsController < ApplicationController

	def new
		@user = User.new
		@chef = Chef.new
	end

	def create
		raise
		@chef = Chef.new(chef_params)

		if @chef.save
			@restaurant = @chef.restaurant.build(restaurant_params)

		else
			render :action => :new
		end

	end

	private

	def chef_params
	  params.require(:chef).permit(
	  	:first_name, :last_name, :phone_number, :birthday,
	  	:SSN, :routing_number, :account_number,

	  	:restaurant_attributes => [
	  		:id, :name, :address, :phone_number,:description,
	  		:city, :state, :ZIP, :tax_ID, :communication_method,
	  	],

	  	:user_attributes => [
	  		:id, :email, :password,
	  	],
	  )
	end

	def restaurant_params
		chef_params[:restaurant_attributes]
	end
end
