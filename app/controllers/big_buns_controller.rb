class BigBunsController < ApplicationController

	before_action :find_chef, :only =>[:update,:create,:edit,:destroy]
	before_action :is_current_user?, :only => [:update, :create,:edit,:destroy]
	before_action :has_authority?, :only => [:update, :create,:edit,:destroy]
	before_action :find_big_bun, :only =>[:update,:edit,:destroy]


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

	  	time_error = false
	  	# 先確認start_time < stop_time

	  	# TODO: check all start_datetime & stop_datetime
	  	# 先確認 A.start_time > B.end_time or A.end_time < B.start_time
	  	big_buns = @chef.big_buns
	  	
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

	def update

  	if params[:is_public]
  		@big_bun.is_public = params[:is_public]

  		if @big_bun.save!
  			redirect_to menu_chef_path(@chef)
  		end

  	elsif params[:big_bun] && @big_bun.update!(big_bun_params)
  		redirect_to menu_chef_path(@chef)

  	else
  		flash[:alert] = "update fail"
			render :action => :back
  	end
  end

  def edit

  end

  def destroy
  	@big_bun.destroy!
  	redirect_to menu_chef_path(@chef)
  end

	private

	def big_bun_params
	  params.require(:big_bun).permit(
	  	:id, :restaurant_id, :style, :unit, :start_datetime, :stop_datetime,
	  	:prepare_time,

	  	:big_bun_photo_attributes => [
		  		:id, :big_bun_id, :photo,
		  ],
	  )
	end

	def find_chef
		@chef = Chef.find(params[:chef_id])
	end

	def find_big_bun
		@big_bun = BigBun.find(params[:id])
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
