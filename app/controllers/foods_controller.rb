class FoodsController < ApplicationController
  def show
  end

  def new
  	@food = Food.new
  	if params[:chef_id]
  		@chef = Chef.find(params[:chef_id])
  	end
  end

  def create
  	if params[:chef_id]
  		@chef = Chef.find(params[:chef_id])
	  	@food = @chef.restaurant.foods.new(food_params)
			if @food.save!
				redirect_to chef_path(@chef)
			else
				flash[:alert] = "add_fish fail"
				render :action => :new
			end
		else
			flash[:alert] = "add_fish fail"
			render :action => :new
		end
  end

  private

  def food_params
	  params.require(:food).permit(
	  	:id, :restaurant_id, :about, :ingredients, :name, :price,
	  	:is_public, :unit, :unit_name, :max_order, :availability_date,

	  	:food_photos_attributes => [
		  		:id, :food_id, :photo,
		  ],
	  )
	end
end
