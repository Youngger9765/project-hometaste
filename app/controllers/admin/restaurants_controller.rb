class Admin::RestaurantsController < ApplicationController

	layout "admin"

	before_action :user_admin?
	before_action :find_restaurant, :only =>[:show, :update, :destroy]

	def index
		@restaurants = Restaurant.all
	end

	def show
		@foods = @restaurant.foods.all
	end

	def update

		if params[:is_approved]
			if params[:is_approved] == "1"
				@restaurant.is_approved = true
				@restaurant.save!

			elsif params[:is_approved] == "0"
				@restaurant.is_approved = false
				@restaurant.save!
			end
		end

		redirect_to :back
	end

	def destroy
		@restaurant.is_live = false
		@restaurant.save!

		if params[:rescue] == "1"
			@restaurant.is_live = true
			@restaurant.save!
		end

		redirect_to :back
	end

	private

	def find_restaurant
		@restaurant = Restaurant.find(params[:id])
	end

end
