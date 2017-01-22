class UsersController < ApplicationController

	before_action :find_user, :except =>[:new]
	before_action :is_current_user?, :except =>[:new]
	before_action :find_order, :only =>[:cancel_order,:not_yet_order,:yep_order]

	def new
		@user = User.new
	end

	def edit
		@cuisines = Cuisine.all
	end

	def update
		@user.update(user_params)

		if @user.save
			flash[:notice] = "Successfully edited"
			redirect_to edit_user_path(@user)
		else
			flash[:alert] = "Fail edited..."
			render :edit
		end
	end

	def purchase
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "not yet")

		datetime_now = Time.now.utc.localtime
		@time_now_to_Num = datetime_now.strftime( "%H%M%S" )
	end

	def paid
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "not yet")
		datetime_now = Time.now.utc.localtime
		@time_now_to_Num = datetime_now.strftime( "%H%M%S" )

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

	private

	def render_js
		respond_to do |format|
			format.js {render 'purchase'}
		end
	end

	def cancel_order
		if @order.order_status != "completed"

			datetime_now = Time.now.utc.localtime
			time_now_to_Num = datetime_now.strftime( "%H%M%S" )

			# check cut off time
			if @order.bulk_buy.present?
				cut_off_time = @order.bulk_buy.cut_off_time.localtime
				cut_off_time_to_Num = cut_off_time.strftime( "%H%M%S" )

				# User can cancel before cut off time
				if time_now_to_Num <= cut_off_time_to_Num
					@order.update(:order_status => "cancelled")
					flash[:notice] = "Successfully cancelled."

					# 要做退款功能

				else
					flash[:notice] = "You can't cancel this order! It is already over cut off time."
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
		if params[:user_not_yet_reason].present?

			# 先確認送餐時間

			# 寄信功能

			# 要做退款功能
			if @order.order_status != "completed" && @order.order_status != "cancelled"
				@order.update(:cancelled_reason => params[:user_not_yet_reason],
											:order_status => "cancelled"
										)
				flash[:notice] = "We already tell chef to check this problem and will refound!"
				redirect_to purchase_user_path(@user)
			else
				flash[:alert] = "You can't modify this order."
				redirect_to purchase_user_path(@user)
			end
		else
			flash[:alert] = "Please choose a reason!"
			redirect_to purchase_user_path(@user)
		end
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

	private

	def user_params
		params.require(:user).permit(
				:name, :gender, :birthday, :phone_number, :address,
				:ZIP, :foodie_id,

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
end
