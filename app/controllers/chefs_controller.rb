class ChefsController < ApplicationController

	before_action :find_chef_restaurant, :only =>[
		:show, :edit, :update, :review, :approve, :add_dish,
		:save_dish, :menu, :sales, :yep, :business, :summary,:delivering,
		:completed,:cancelled]

	before_action :find_user, :only =>[
		:show, :edit, :update, :review, :approve, :add_dish,
		:save_dish, :menu, :sales, :yep, :summary,:delivering,
		:completed,:cancelled]

	# before_action :is_current_user?, :except => [:new]
	# before_action :has_authority?, :except => [:new]
	before_action :user_admin?, :only => [:approve, :review]
	before_action :find_orders, :only => [:sales,:summary, :delivering, :advance,:completed,:cancelled]

	def new
		@user = User.new
		@chef = Chef.new
	end

	def create
		create_pass = true
		flash[:alert] = []

		@chef = Chef.new(chef_params)

		# check email
		if User.find_by(:email => user_params[:email])
			create_pass = false
			flash[:alert] << "user exist!"
		else
			# create user
			@user = User.new(user_params)
			@user.name = chef_params[:first_name]
			@user.foodie_id = chef_params[:first_name]
			@user.phone_number = chef_params[:phone_number]
			@user.is_chef = true

			if !params[:chef][:user_attributes][:password].blank?
				@user.password = params[:chef][:user_attributes][:password]
			else
				flash[:alert] << "password fail"
			end

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
					flash[:alert] << "save chef fail"
				end

			# save user fail
			else
				create_pass = false
				flash[:alert] << "save user fail"
			end
		end

		if create_pass
			flash[:notice] = "Chef create done, please confirm by email."
			redirect_to main_index_path
		else

			@user = User.new
			@chef = Chef.new(chef_params)
			flash[:alert] << "Register chef fail"
			redirect_to new_chef_path
		end

	end

	# show
	def sales
		today_orders = @paid_process_orders.where(order_status: "process").where(:pick_up_time => @today_time_range)
		@orders = today_orders.where( ["pick_up_time > ?", @datetime_now_to_utc] )
	end

	def summary
		# Today's ORDERS
		today_orders = @paid_process_orders.where(order_status: "process").where(:pick_up_time => @today_time_range)
		@orders = today_orders.where(["pick_up_time > ?",@datetime_now_to_utc])
		render_js
	end

	def advance
		# @order 這邊需要幫我寫一下怎麼生出@order
		render_js
	end

	def delivering
		@orders = @paid_process_orders.where(order_status: "process").where(["pick_up_time < ?",@datetime_now_to_utc])
		render_js
	end

	def completed
		@orders = @paid_process_orders.where(:order_status => 'completed')
		render_js
	end

	def cancelled
		@orders = @paid_process_orders.where(:order_status => 'cancelled')
		render_js
	end

	def business
	end

	def edit
	end

	def update
		if !params[:chef][:user_attributes][:password].blank?
			@chef.user.password = params[:chef][:user_attributes][:password]
			@chef.user.save!
		end

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


	def yep
		confirmation_number = params[:confirmation_number]
		order = Order.find(params[:order_id])

		if confirmation_number.present?
			if confirmation_number == order.confirmation_number
				order.order_status = "completed"
				order.save!
				flash[:notice] = "Successfully completed order"
			else
				flash[:alert] = "Confirmation number is wrong!"
			end
		else
			flash[:alert] = "Please input confirmation number"
		end
		redirect_to chef_path(@chef)
	end

	private

	def render_js
		respond_to do |format|
			format.js {render 'sales'}
		end
	end


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
	  		:id, :email,

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

	def find_chef_restaurant
		@chef = Chef.find(params[:id])
		@restaurant = @chef.restaurant
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

	def find_orders
		@paid_process_orders = @restaurant.orders.where(:payment_status => "paid")
		# UTC time
		datetime_now = Time.now
		@datetime_now_to_utc = datetime_now.utc

		# 要確認時區的開始時間
		# TODO:加入request 的time_zone
		local_datetime_beginning = Time.now.utc.localtime.beginning_of_day
		local_datetime_end = Time.now.utc.localtime.end_of_day

		@local_datetime_beginning_to_utc = local_datetime_beginning.utc
		@local_datetime_end_to_utc = local_datetime_end.utc
		@today_time_range = (@local_datetime_beginning_to_utc..@local_datetime_end_to_utc)
	end
end
