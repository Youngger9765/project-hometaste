class ApiV1::SearchController < ApplicationController
  before_action :deal_keyword_and_location_string ,only: :keyword
  before_action :get_user_lat_and_long ,only: :keyword
  before_action :deal_params ,only: :filter

  def filter
    get_search_results_from_cookies

    if cookies.signed[:location].nil?
      @lat = request.location.latitude
      @long = request.location.longitude
    else
      @lat,@long = cookies.signed[:location]
    end

    if @food_ids
      @food = Food.filter( @price , @features , @distance, [@lat,@long] , @sort , @cuisine , @foods )
    elsif @restaurant_ids
      @restaurant = Restaurant.filter( @price , @features , @distance, [@lat,@long] , @sort , @cuisine , @restaurants )
    end

    respond_to do |format|
      format.js {render 'api_v1/search/results'}
    end
  end

  def keyword
    restaurants = Restaurant.get_around_restaurants( 10000 ,@lat,@long)
    case @keyword
    when 'Kitchenorchef' ; @restaurants = restaurants
    when 'Mostpopular'   ; @foods = restaurants.get_popular_foods
    when 'Newinstore'    ; @foods = restaurants.new_in_foods
    else
      @foods = Food.ransack(name_cont_any:@keyword)
                   .result(distinct: true)
                   .joins(:restaurant)
                   .where(restaurant_id:restaurants.ids)
    end

    @sum_qty = @restaurants ? @restaurants.size : @foods.size

    save_search_results_location_in_cookies

    respond_to do |format|
      format.js {render 'api_v1/search/results'}
    end
  end

  private

  def deal_keyword_and_location_string
    @location = params[:location].to_s.gsub(/[^a-zA-Z0-9\-]/,'')
    @keyword = params[:keyword].to_s.gsub(/[^a-zA-Z0-9\-]/,'')
  end

  def get_search_results_from_cookies
    _type = cookies.signed[:search_results].keys[0]
    instance_variable_set("@#{_type}_ids", cookies.signed[:search_results][_type])
  end

  def deal_params
    @sort = params[:checked_list_name]['Sort By']
    @distance = params[:checked_list_name]['Distance']
    @price = params[:checked_list_name]['Price']
    @cuisine = params[:checked_list_name]['Cuisine']
    @features = params[:checked_list_name]['Features']
  end

  def get_user_lat_and_long
    if Geocoder.coordinates(@location)
      @lat ,@long = Geocoder.coordinates(@location)
    else
      @lat = request.location.latitude
      @long = request.location.longitude
    end
  end

  def save_search_results_location_in_cookies
    cookies.signed[:search_results] = if @foods
                                        {value: {food: @foods.ids} }
                                      else
                                        {value: {restaurant: @restaurants.ids} }
                                      end
    cookies.signed[:location] = [@lat,@long]
  rescue
    cookies.signed[:search_results] = {}
  end
end
