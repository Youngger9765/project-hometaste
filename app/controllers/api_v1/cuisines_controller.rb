class ApiV1::CuisinesController < ApplicationController
  before_action :find_cuisine

  def get_foods
    @foods = if approved_restaurant.present?
               @cuisine.foods.where('restaurant_id = ?',approved_restaurant.ids)
             else
               @cuisine.foods
             end
    @food_available_bigbun_array = food_available_bigbun_array
    respond_to do |format|
      format.js {render 'api_v1/cuisines/results'}
    end
  end

  def get_restaurants
    @restaurants = if approved_restaurant.present?
                     @cuisine.restaurants.where('id = ?',approved_restaurant.ids)
                   else
                     @cuisine.restaurants
                   end
    respond_to do |format|
      format.js {render 'api_v1/cuisines/results'}
    end
  end

  private

  def food_available_bigbun_array
    array = []
    @foods.each do |food|
      if food.get_available_bigbun
        array << [food, food.get_available_bigbun]
      end
    end
    array
  end

  def find_cuisine
    @cuisine = Cuisine.find(params[:cuisine_id])
  end

  def get_lat_long
    @lat = request.location.data['latitude'].to_f
    @long = request.location.data['longitude'].to_f
  end

  def approved_restaurant
    Restaurant.get_around_restaurants( 5 ,@lat,@long).where(:is_approved => true)
  end
end
