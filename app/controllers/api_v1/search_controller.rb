class ApiV1::SearchController < ApplicationController
  before_action :get_keyword_and_location ,only: :keyword
  before_action :get_user_lat_and_long ,only: :keyword

  def filter
    get_cookies_search_results

    if cookies.signed[:location].nil?
      @lat = request.location.latitude
      @long = request.location.longitude
    else
      @lat,@long = cookies.signed[:location]
    end

    if @food_ids
      @foods = Food.filter( params[:checked_list] , [@lat, @long] )
    elsif @restaurant_ids
      @restaurants = Restaurant.filter( params[:checked_list] , [@lat, @long] )
    end

    respond_to do |format|
      format.js { render 'api_v1/search/results' }
    end
  end

  def keyword
    restaurants = Restaurant.get_around_restaurants(50000, @lat, @long)
    case @keyword
    when 'Kitchenorchef' then @restaurants = restaurants
    when 'Mostpopular'   then @foods = restaurants.get_popular_foods
    when 'Newinstore'    then @foods = restaurants.new_in_foods
    else
      @foods = Food.ransack(name_cont_any: @keyword)
                   .result(distinct: true)
                   .joins(:restaurant)
                   .where(restaurant_id: restaurants.ids)
      if @foods.size == 0
        @restaurants = Restaurant.ransack(name_cont_any: @keyword)
                           .result(distinct: true)
                           .where(id: restaurants.ids)
      end
    end

    @sum_qty = @restaurants ? @restaurants.size : @foods.size

    save_results_in_cookies

    respond_to do |format|
      format.js {render 'api_v1/search/results'}
    end
  end

  private

  def get_keyword_and_location
    @location = params[:location].to_s.gsub(/[^a-zA-Z0-9\-]/,'')
    @keyword = params[:keyword].to_s.gsub(/[^a-zA-Z0-9\-]/,'')
  end

  def get_cookies_search_results
    _type = cookies.signed[:search_results].keys.first
    instance_variable_set("@#{_type}_ids", cookies.signed[:search_results][_type])
  end

  def get_user_lat_and_long
    if Geocoder.coordinates(@location)
      @lat, @long = Geocoder.coordinates(@location)
    elsif Geocoder.coordinates(current_user.try(:address))
      @lat, @long = Geocoder.coordinates(current_user.address)
    else
      @lat = request.location.data['latitude'].to_f
      @long = request.location.data['longitude'].to_f
    end
  end

  def save_results_in_cookies
    cookies.signed[:search_results] = if @foods.present?
                                        {value: {food: @foods.ids} }
                                      else
                                        {value: {restaurant: @restaurants.ids} }
                                      end
    cookies.signed[:location] = [@lat,@long]
  rescue
    cookies.signed[:search_results] = {}
  end
end
