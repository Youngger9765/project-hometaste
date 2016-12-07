class Admin::UsersController < ApplicationController

	layout "admin"

	before_action :user_admin?
	before_action :find_user, :only =>[:update, :destroy]

	def index
		@users = User.all
	end

	def update

		if params[:is_ban]

			if params[:is_ban] == "1"
				@user.is_ban = true
				@user.save!

			elsif params[:is_ban] == "0"
				@user.is_ban = false
				@user.save!
			end
		end

		redirect_to admin_path
	end

	def destroy
		@user.is_live = false
		@user.save!

		if params[:rescue] == "1"
			@user.is_live = true
			@user.save!
		end
		

		redirect_to admin_path
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

end
