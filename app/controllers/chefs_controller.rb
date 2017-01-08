class ChefsController < ApplicationController

	before_action :find_chef, :only =>[
		:show, :edit, :update, :review, :approve, :add_dish,
		:save_dish, :menu, :sales]

	before_action :find_user, :only =>[
		:show, :edit, :update, :review, :approve, :add_dish,
		:save_dish, :menu, :sales]

	before_action :is_current_user?, :except => [:new]
	before_action :has_authority?, :except => [:new]
	before_action :user_admin?, :only =>[:approve, :review]

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
			@user.foodie_id = chef_params[:first_name]
			@user.phone_number = chef_params[:phone_number]
			@user.is_chef = true

			# save user pass
			if @user.save
					@chef.user = @user

				# save chef & restaurant & delivery & bulk_buys
				if @chef.save

					if !bulk_buy_checked
						@chef.restaurant.bulk_buys.destroy_all
					end

					if !delivery_checked && @chef.restaurant.delivery
						@chef.restaurant.delivery.destroy_all
					end

				else
					@user.destroy
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

	def show
	end

	def edit

	end

	def update
		if @chef.update!(chef_params)
			redirect_to chef_path(@chef)
		else
			flash[:alert] = "update fail"
			render :action => :edit
		end
	end

	def review
	end

	def approve
		@restaurant = @chef.restaurant
		if @restaurant.update(:is_approved => true)
			redirect_to chef_path(@chef)
		else
			flash[:alert] = "approve fail"
			render :action => :review
		end
	end

	def menu
		@foods = @chef.restaurant.foods.all
		@big_buns = @chef.restaurant.big_buns.all
	end

	def sales
		time_range = (Time.now().beginning_of_day()..Time.now().end_of_day())
		@today_orders = @chef.restaurant.orders.where(:created_at => time_range).where(:payment_status => "paid")
		@cancelled_orders = @chef.restaurant.orders.where(:order_status => "cancelled")
		@completed_orders = @chef.restaurant.orders.where(:order_status => "completed")
		respond_to do |format|
		  format.html
		  format.js
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
	  		:certificated_img, :certificated_num, :main_photo, :tax,
	  		:order_reach,

	  		:delivery_attributes => [
		  		:id, :min_order, :area, :distance, :cost, :order_hours,
		  	],

		  	:bulk_buys_attributes => [
		  		:id, :cut_off_time, :location, :pick_up_time,
		  	],

		  	:restaurant_cuisine_ships_attributes => [
		  		:id, :restaurant_id, :cuisine_id,
		  	],

		  	:restaurant_dish_photos_attributes => [
		  		:id, :restaurant_id, :photo, :comment,
		  	],
	  	],

	  	:user_attributes => [
	  		:id, :email, :password,

	  		:user_photo_attributes => [
		  		:id, :user_id, :photo,
		  	],
	  	],
	  )
	end

	def user_params
		chef_params[:user_attributes]
	end

	def restaurant_params
		chef_params[:restaurant_attributes]
	end

	def delivery_params
		restaurant_params[:delivery_attributes]
	end

	def delivery_checked
		params[:delivery_only]
	end

	def bulk_buy_checked
		params[:bulk_buy_only]
	end

	def find_chef
		@chef = Chef.find(params[:id])
	end

	def find_user
		@user = @chef.user
	end

	def is_current_user?
		if current_user && @user == current_user
			true
		else
			flash[:alert] = "Please Login"
			redirect_to root_path
		end
	end

	def has_authority?
		if current_user && (current_user.is_chef || current_user.is_admin)
			true
		else
			flash[:alert] = "No authority!"
			redirect_to root_path
		end
	end
end
