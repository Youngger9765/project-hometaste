class ApiV1::SearchController < ApplicationController

  def filter
    params
  end

  def keyword
    deal_keyword_and_near_string
    get_user_lat_and_long
    restaurants = get_around_restaurants(10000)
    if @keyword == 'Kitchenorchef'
      @restaurants = restaurants
    elsif @keyword == 'Most popular'
      @foods = restaurants.foods.joins(:food_comments).order('food_comments.score desc')
    elsif @keyword == 'Newinstore'
      @foods = restaurants.foods.where('foods.updated_at > ?', Time.current - 7.days )
    else
      @foods = Food.ransack(name_cont_any:@keyword)
                   .result(distinct: true)
                   .joins(:restaurant)
                   .where(restaurant_id:restaurants.ids)
    end

    save_search_results_in_cookies

    respond_to do |format|
      format.js
    end
  end

  private

  def deal_keyword_and_near_string
    @keyword = params[:text].gsub!(/[^a-zA-Z0-9\-]/,'')
    @near = params[:near].gsub!(/[^a-zA-Z0-9\-]/,'')
  end

  def get_user_lat_and_long
    if Geocoder.coordinates(@near)
      @lat ,@long = Geocoder.coordinates(@near)
    else
      @lat = request.location.latitude
      @lon = request.location.longitude
      # @lat = 43.9
      # @lon = -98.6
    end
  end

  def get_around_restaurants( km = 10000 , restaurants = Restaurant.all )
    restaurant_ids = []
    restaurants.each do |restaurant|
      restaurant_ids << restaurant.id if restaurant.distance_to([@lat,@lon],:km) < km
    end
    Restaurant.where(id:restaurant_ids)
  end

  def save_search_results_in_cookies
    cookies[:search_results] = {foods: @foods.ids} if @foods
    cookies[:search_results] = {restaurants: @restaurants.ids} if @restaurants
  end
end
