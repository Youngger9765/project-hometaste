class ChefsController < ApplicationController

	def new
		@user = User.new
		@chef = Chef.new
	end

	def create
		create_pass = true
		@chef = Chef.new(chef_params)

		# check email
		if User.find_by(:email => user_params[:email])
			create_pass = false
		else
			# create user
			@user = User.new(user_params)
			@user.name = chef_params[:first_name]
			@user.user_name = chef_params[:first_name]
			@user.phone_number = chef_params[:phone_number]
			@user.is_chef = true

			# save user pass
			if @user.save
					@chef.user = @user

				# save chef & restaurant
				if @chef.save

				else
					create_pass = false
				end

			# save user fail
			else
				create_pass = false
			end
		end

		if create_pass
			flash[:notice] = "Chef create done, please confirm by email."
			redirect_to main_index_path
		else

			@user = User.new
			@chef = Chef.new(chef_params)
			flash[:alert] = "create fail"
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

	def user_params
		chef_params[:user_attributes]
	end

	def restaurant_params
		chef_params[:restaurant_attributes]
	end
end
