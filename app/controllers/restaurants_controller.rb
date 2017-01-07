class RestaurantsController < ApplicationController

	before_action :find_restaurant, :except => [:index]
	before_action :find_chef, :except => [:index]

  def index
    @user = User.new
  end

  def show
    @user = current_user || User.new

    time_range = (Time.now().beginning_of_day()..Time.now().end_of_day())
		@today_orders = @chef.restaurant.orders.where(:created_at => time_range).where(:payment_status => "paid")
  	@reach_percent = (@today_orders.sum(:amount)*100/@restaurant.order_reach).to_f
  end

  private

  def find_restaurant
  	@restaurant = Restaurant.includes(:big_buns,:bulk_buys).find(params[:id])
  end

  def find_chef
  	@chef = @restaurant.chef
  end

end
