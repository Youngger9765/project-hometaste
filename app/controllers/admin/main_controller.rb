class Admin::MainController < ApplicationController

	layout "admin"
	# before_action :authenticate_user!
  before_action :user_admin?

	def index
		@users = User.all
	end

	def destroy
		
	end

end
