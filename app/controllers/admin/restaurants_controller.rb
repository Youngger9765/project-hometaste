class Admin::RestaurantsController < ApplicationController

	layout "admin"

	before_action :user_admin?

	def index
		
	end

end
