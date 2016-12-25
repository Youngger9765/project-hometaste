class FoodsController < ApplicationController

	before_action :find_chef, :only =>[:update,:create,:edit,:destroy]
	before_action :is_current_user?, :only => [:update, :create,:edit,:destroy]
	before_action :has_authority?, :only => [:update, :create,:edit,:destroy]
	before_action :find_food, :only =>[:update,:edit,:destroy]

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

  def update

  	if params[:is_public]
  		@food.is_public = params[:is_public]

  		if @food.save!
  			redirect_to menu_chef_path(@chef)
  		end

  	elsif params[:food] && @food.update!(food_params)
  		redirect_to menu_chef_path(@chef)

  	else
  		flash[:alert] = "update fail"
			render :action => :back
  	end
  end

  def edit

  end

  def destroy
  	@food.destroy!
  	redirect_to menu_chef_path(@chef)
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

	def find_chef
		@chef = Chef.find(params[:chef_id])
	end

	def find_food
		@food = Food.find(params[:id])
	end

	def is_current_user?
		if current_user && @chef.user == current_user
			true
		else
			flash[:notice] = "Please Login"
			redirect_to :back
		end
	end

	def has_authority?
		if current_user && (current_user.is_chef || current_user.is_admin)
			true
		else
			flash[:alert] = "No authority!"
			redirect_to :back
		end
	end


end
