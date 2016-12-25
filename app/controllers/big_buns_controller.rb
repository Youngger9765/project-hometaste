class BigBunsController < ApplicationController

	def new
		@big_bun = BigBun.new
  	if params[:chef_id]
  		@chef = Chef.find(params[:chef_id])
  	end
	end

	def create
		if params[:chef_id]
  		@chef = Chef.find(params[:chef_id])
	  	@big_bun = @chef.restaurant.big_buns.new(big_bun_params)
			if @big_bun.save!
				redirect_to chef_path(@chef)
			else
				flash[:alert] = "add_big_bun fail"
				render :action => :new
			end
		else
			flash[:alert] = "add_big_bun fail"
			render :action => :new
		end
	end

	private

	def big_bun_params
	  params.require(:big_bun).permit(
	  	:id, :restaurant_id, :style, :unit, :start_datetime, :stop_datetime,

	  	:big_bun_photo_attributes => [
		  		:id, :big_bun_id, :photo,
		  ],
	  )
	end
end
