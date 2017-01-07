class RestaurantsController < ApplicationController

  def index
    @user = User.new
  end

  def show
    @user = current_user || User.new
    @restaurant = Restaurant.includes(:big_buns,:bulk_buys).find(params[:id])
  end

end
