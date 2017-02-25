class CommentsController < ApplicationController
  before_action :find_restaurant

  def show
    @comment = FoodComment.new
    @foods = @restaurant.foods
    @comments = @restaurant.foods
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

end
