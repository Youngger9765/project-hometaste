class UsersController < ApplicationController

	before_action :find_user, :only =>[:edit]
	before_action :is_current_user?, :only =>[:edit]

	def new
		@user = User.new
	end

	def edit
		
	end

	private

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
