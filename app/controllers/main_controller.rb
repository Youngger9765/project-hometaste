class MainController < ApplicationController

	def index
		@user = User.new
		@foods = Food.all.includes(:restaurant).sample(100)
	end
end
