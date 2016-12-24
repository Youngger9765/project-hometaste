class Admin::OrdersController < ApplicationController

	layout "admin"
	# before_action :authenticate_user!
  before_action :user_admin?

	def index
		if params[:restaurant]
			@restaurant_search= Restaurant.new(:name => params[:restaurant][:name])
			restaurant_ids = Restaurant.where('name LIKE ?', "%#{params[:restaurant][:name]}%").pluck(:id)
			@q = Order.where(:restaurant_id => restaurant_ids).ransack(params[:q])

		elsif params[:user]
			@user_search = User.new(:foodie_id => params[:user][:foodie_id])
			user_ids = User.where('foodie_id LIKE ?', "%#{params[:user][:foodie_id]}%").pluck(:id)
			@q = Order.where(:user_id => user_ids).ransack(params[:q])

		else
			@restaurant_search = Restaurant.new
			@user_search = User.new
			@q = Order.ransack(params[:q])
		end

    @orders = @q.result(distinct: true)
    @orders = @orders.page(params[:page]).per(5)
	end

	def today
		@orders = Order.where("created_at >= ?", Time.zone.now.beginning_of_day)

		if params[:restaurant]
			@restaurant_search= Restaurant.new(:name => params[:restaurant][:name])
			restaurant_ids = Restaurant.where('name LIKE ?', "%#{params[:restaurant][:name]}%").pluck(:id)
			@q = @orders.where(:restaurant_id => restaurant_ids).ransack(params[:q])

		elsif params[:user]
			@user_search = User.new(:foodie_id => params[:user][:foodie_id])
			user_ids = User.where('foodie_id LIKE ?', "%#{params[:user][:foodie_id]}%").pluck(:id)
			@q = @orders.where(:user_id => user_ids).ransack(params[:q])

		else
			@restaurant_search = Restaurant.new
			@user_search = User.new
			@q = @orders.ransack(params[:q])
		end

    @orders = @q.result(distinct: true)
    @orders = @orders.page(params[:page]).per(5)
	end

end
