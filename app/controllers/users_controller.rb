class UsersController < ApplicationController

	before_action :find_user, :except =>[:new, :like, :unlike]
	before_action :is_current_user?, :except =>[:new, :like, :unlike]
	before_action :find_order, :only =>[:cancel_order,:not_yet_order,:yep_order]

	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "72yk9y5dxms9gxf9"
	Braintree::Configuration.public_key = "n3tn23y52b346z3x"
	Braintree::Configuration.private_key = "dd8841579f3ee81053baddadbb4da98a"

	def new
		@user = User.new
	end

	def edit
		@cuisines = Cuisine.all
		@prefered_cuisine_ids = @user.prefered_cuisine_ids || []
	end

	def update
		@user.update(user_params)

		# save prefered_food_ids
		@user.prefered_cuisine_ids = []
		params[:user][:prefered_cuisine_ids].each do |id|
			@user.prefered_cuisine_ids << id.to_i
		end

		if @user.save
			flash[:notice] = "Successfully edited"
			redirect_to edit_user_path(@user)
		else
			flash[:alert] = "Fail edited..."
			render :edit
		end
	end

	def message; end

	def like
		user_id = params[:user_id]
		@restaurant_id = params[:restaurant_id]
		@food_id = params[:food_id]

		if user_id.present?
			if @restaurant_id.present?
				liking = UserRestaurantLiking.new(user_id: user_id, restaurant_id: @restaurant_id)
				liking.save!
        @liking_restaurant_size = Restaurant.find(@restaurant_id).user_restaurant_likings.size
			elsif @food_id.present?
				liking = UserFoodLiking.new(user_id: user_id, food_id: @food_id)
				liking.save!
        @liking_food_size = Food.find(@food_id).user_food_likings.size
			end
		end

		respond_to do |format|
			format.js {render 'like'}
		end
	end

	def unlike
		user_id = params[:user_id]
		@restaurant_id = params[:restaurant_id]
		@food_id = params[:food_id]

		if user_id.present?
			if @restaurant_id.present?
				liking = UserRestaurantLiking.find_by(:user_id => user_id, :restaurant_id => @restaurant_id)
				liking.destroy
        @liking_restaurant_size = Restaurant.find(@restaurant_id).user_restaurant_likings.size
			elsif @food_id.present?
				liking = UserFoodLiking.find_by(:user_id => user_id, :food_id => @food_id)
				liking.destroy
        @liking_food_size = Food.find(@food_id).user_food_likings.size
			end
		end

		respond_to do |format|
			format.js {render 'like'}
		end
	end

	def review
    @food_comments = FoodComment.first(3)
	end

	def kitchen
		@liking_restaurants = @user.liking_restaurants
		@datetime_now = Time.now.utc.localtime
	end

	def liked
		@liking_restaurants = @user.liking_restaurants.includes(:restaurant_comments, :liking_users, :orders)
		@liking_foods = @user.liking_foods.includes(:food_comments, :liking_users, :restaurant)
		@datetime_now = Time.now.utc.localtime
	end

	def purchase
		@client_token = Braintree::ClientToken.generate
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "process")
		@datetime_now = Time.now.utc.localtime
		@time_now_to_Num = @datetime_now.strftime( "%H%M%S" )
	end

	def paid
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "process")
		@datetime_now = Time.now.utc.localtime
		@time_now_to_Num = @datetime_now.strftime( "%H%M%S" )

		render_js
	end

	def completed
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "completed")
		render_js
	end

	def cancelled
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "cancelled")
		render_js
	end

	def big_bun
		render_js
	end

	def cancel_order
		if @order.order_status != "completed"

			datetime_now = Time.now.utc.localtime
			time_now_to_Num = datetime_now.strftime( "%H%M%S" )

			# check cut off time
			if @order.bulk_buy.present?
				check_order_cut_off_time(@order)

				if @cancel_availible
					@order.update(:order_status => "cancelled")
					flash[:notice] = "Successfully cancelled."

					# Refund
					order_refund

				else
					flash[:alert] = "You can't cancel this order! It is already over cut off time."
				end
			else
				# check delivery

			end

		else
			flash[:alert] = "You can't cancel this order! It is already completed."
		end

		redirect_to purchase_user_path(@user)
	end

	def not_yet_order

		# 先確認送餐時間  TODO: 確認local time
		datetime_now = Time.now
		datetime_now_to_utc = datetime_now.utc

		if datetime_now_to_utc < @order.pick_up_time.utc
			flash[:alert] = "Please wait till pick up time!"

		else
			if params[:user_not_yet_reason].present?
				if @order.order_status != "completed" && @order.order_status != "cancelled"
					@order.update(:cancelled_reason => params[:user_not_yet_reason],
												:order_status => "cancelled"
											)
					# Mail
					UserMailer.user_not_yet_order(current_user, @order.cancelled_reason).deliver_now!

					# Refund
					order_refund

				else
					flash[:alert] = "You can't modify this order."
				end
			else
				flash[:alert] = "Please choose a reason!"
			end

		end

		redirect_to purchase_user_path(@user)
	end

	def yep_order
		if @order.order_status != "cancelled"
			@order.update(:order_status => "completed")
			flash[:notice] = "Successfully completed."
			redirect_to purchase_user_path(@user)
		else
			flash[:alert] = "You can't modify this order. It is already cancelled."
			redirect_to purchase_user_path(@user)
		end
	end

	def get_conversation_messages
		conversation_id = params[:conversation]
		@conversation = @user.conversations.find(conversation_id)
		@recipient = User.find(@conversation.recipient_id)
		@messages = @conversation.messages

		respond_to do |format|
		    format.js
		end
	end

	private

	def render_js
		respond_to do |format|
			format.js {render 'purchase'}
		end
	end

	def user_params
		params.require(:user).permit(
				:name, :last_name, :gender, :birthday, :phone_number, :address,
				:ZIP, :foodie_id, :prefered_cuisine_ids,

				:user_photo_attributes => [
						:photo
				]
		)
	end

	def find_user
		@user = User.find(params[:id])
	end

	def is_current_user?
		if current_user && @user == current_user

		else
			flash[:alert] = "You have no athuroity!"
			redirect_to root_path
		end
	end

	def find_order
		@order = Order.find(params[:order_id])
	end

	def check_order_cut_off_time(order)
		datetime_now = Time.now.utc.localtime
		time_now_to_Num = datetime_now.strftime( "%H%M%S" )
		@cancel_availible = false
		# <!-- 昨天以前的order -->
		if order.pick_up_time.localtime.to_date < datetime_now.to_date
            @cancel_availible = false

        # <!-- 今天的order -->
        elsif order.pick_up_time.localtime.to_date == datetime_now.to_date
          # <!-- 如果超過了 cut-off time -->
          	if order.bulk_buy.cut_off_time.localtime.strftime("%H%M%S") < time_now_to_Num
            	@cancel_availible = false
         	else
            	@cancel_availible = true
          	end

        # <!-- 明天以後的order -->
        else
          	@cancel_availible = true
        end
	end

	def order_refund
		# Refund
		nonce_from_the_client = params["payment-method-nonce"]

		if @order.confirmation_number.present?
			transaction = Braintree::Transaction.find(@order.confirmation_number)
			transaction_status = transaction.status

			if transaction_status == "submitted_for_settlement"
				result = Braintree::Transaction.void(@order.confirmation_number)
			elsif transaction_status == "settled"
				result = Braintree::Transaction.refund(@order.confirmation_number)
			end
		end

		if result.success?
			flash[:notice] = "We already tell chef to check this problem and will refound!"
		else
			flash[:notice] = "We already tell chef and deal with your payment!"
		end
	end
end
