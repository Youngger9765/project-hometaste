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

	  	check_big_bun_time

	  	if !@time_error
	  		if @big_bun.save!
					redirect_to menu_chef_path(@chef)
				else
					flash[:alert] = "add_big_bun fail"
					render :action => :new
				end

	  	else
	  		flash[:alert] << "add_big_bun fail, pls check time setting"
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

  	else
  		check_big_bun_time

	  	if !@time_error
	  		if params[:big_bun] && @big_bun.update!(big_bun_params)
					redirect_to menu_chef_path(@chef)
				else
					flash[:alert] = "update fail"
					redirect_to edit_chef_big_bun_path(@chef,@big_bun)
				end

	  	else
	  		flash[:alert] << " update big_bun fail, pls check time setting"
				redirect_to edit_chef_big_bun_path(@chef,@big_bun)
	  	end
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

	def check_big_bun_time
		@time_error = false
  	flash[:alert] = []
  	start_datetime = big_bun_params[:start_datetime]
  	stop_datetime = big_bun_params[:stop_datetime]

  	start_datetime_i = start_datetime.to_time.to_i
  	stop_datetime_i = stop_datetime.to_time.to_i

  	prepare_time = big_bun_params[:prepare_time]
  	prepare_hour = big_bun_params[:'prepare_time(4i)'].to_i
  	prepare_min = big_bun_params[:'prepare_time(5i)'].to_i
  	start_to_prepare_datetime_to_i = (start_datetime.to_time + prepare_hour.hours + prepare_min.minute).to_i

  	# 確認start_time < stop_time
  	if start_datetime_i > stop_datetime_i
  		@time_error = true
  		flash[:alert] << "start_datetime should be earlier than stop_datetime"
  	end

  	# 確認start_time + prepare time < stop_time
  	if start_to_prepare_datetime_to_i > stop_datetime_i
  		@time_error = true
  		flash[:alert] << "prepare time too much"
  	end

  	# TODO: check all self big_buns start_datetime & stop_datetime
  		# 先確認 A.start_time > B.end_time or A.end_time < B.start_time
	end
end
