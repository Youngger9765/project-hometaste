class UsersController < ApplicationController

	before_action :find_user, :except =>[:new]
	before_action :is_current_user?, :only =>[:edit, :update]

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
	end

	def paid
		@orders = @user.orders.where(:payment_status => "paid").where(:order_status => "not yet")
		render_js
	end

	def completed
		render_js
	end

	def cancelled
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
end
