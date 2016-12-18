class ApiV1::SearchController < ApplicationController
  before_action :deal_keyword
  before_action :get_user_location

  def filter
    params
  end

  def keyword
    foods = Food.ransack(name_cont_any:@keyword).result(distinct: true)
    if @near == 'Kitchenorchef'
      restaurants = Restaurant.ransack( name_cont_any_or_description_cont_any:@keyword ).result( distinct: true )
      restaurants = get_around_restaurants( restaurants )
    elsif @near == 'Most popular'

    elsif @near == 'Newinstore'
      foods = get_around_restaurants.joins(:foods).where('foods.updated_at > ?', Time.current - 7.days )
    end
    restaurants = Restaurant.ransack(name_cont_any_or_description_cont_any:@keyword, address_cont_any:@near).result(distinct: true)

  end

  private

  def deal_keyword
    @keyword = params[:text].gsub!(/[^a-zA-Z0-9\-]/,'')
    @near = params[:near].gsub!(/[^a-zA-Z0-9\-]/,'')
  end

  def get_user_location
    @_lat = request.location.latitude
    @_lon = request.location.longitude
    @lat = 43.9
    @lon = -98.6
  end

  def get_around_restaurants( restaurants = Restaurant.all , km = 10000 )
    restaurant_ids = []
    restaurants.each do |restaurant|
      restaurant_ids << restaurant.id if restaurant.distance_to([@lat,@lon],:km) < km
    end
    Restaurant.where(id:restaurant_ids)
  end

end
