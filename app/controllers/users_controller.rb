class UsersController < ApplicationController

	before_action :find_user, :only =>[:edit, :update]
	before_action :is_current_user?, :only =>[:edit, :update]

	def new
		@user = User.new
	end

	def edit
		
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

	private

	def user_params
	  params.require(:user).permit(
	  	:name, :gender, :birthday, :phone_number, :address,
	  	:ZIP, :foodie_id,
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
