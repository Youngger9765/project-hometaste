class Admin::RestaurantsController < ApplicationController

	layout "admin"

	before_action :user_admin?

	def index
		@restaurants = Restaurant.all
	end

end
