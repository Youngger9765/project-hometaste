class Admin::UsersController < ApplicationController

	before_action :find_user

	def index
		raise
	end

	def update
		if @user.update(user_params)
			redirect_to admin_path
		else
			redirect_to :back
		end
	end

	def destroy
		@user.is_live = false
		@user.save!

		redirect_to admin_path
	end

	private

	def user_params
    params.require(:user).permit(:is_ban)
  end

	def find_user
		@user = User.find(params[:id])
	end

end
