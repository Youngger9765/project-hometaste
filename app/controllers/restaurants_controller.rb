class RestaurantsController < ApplicationController

  def index
    @user = User.new
  end

  def show
    @user = current_user || User.new
    @restaurant = Restaurant.find(params[:id])
  end

end
