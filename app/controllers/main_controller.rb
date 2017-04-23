class MainController < ApplicationController

  before_action :get_today_foods_ids

  def index
    @lat = request.location.data['latitude'].to_f
    @long = request.location.data['longitude'].to_f

    approved_restaurant = Restaurant.get_around_restaurants( 5 ,@lat,@long).where(:is_approved => true)
    @foods = Food.where(:restaurant_id => approved_restaurant.ids)
                 .includes(:restaurant, :cuisines, :food_photos)
                 .today_foods(@foods_ids)
    @cuisines = Cuisine.all
    @food_available_bigbun_array = @foods.available_bigbun

    save_search_results_in_cookies
  end

  def terms; end

  def conditions; end

  # restaurant's feature
  # today_meal_restaurant_ids = Food.where(:is_public => true).pluck(:restaurant_id).uniq
  # @today_meal = approved_restaurant.where(id: today_meal_restaurant_ids)
  #
  # bulk_buy_restaurant_ids = BulkBuy.pluck(:restaurant_id).uniq
  # @bulk_buy = approved_restaurant.where(id:bulk_buy_restaurant_ids)
  #
  # delivery_restaurant_ids = Delivery.pluck(:restaurant_id).uniq
  # @delivery = approved_restaurant.where(id:delivery_restaurant_ids)
  #
  # big_bun_restaurant_ids = BigBun.where(:is_public => true).pluck(:restaurant_id).uniq
  # @offer_big_bun = approved_restaurant.where(id:big_bun_restaurant_ids)


  private

  def save_search_results_in_cookies
    cookies.signed[:search_results] = {value: {food: @foods.ids} }
  end

  def get_today_foods_ids
    wday_now = Time.now.localtime.wday
    @foods_ids =[]
    public_foods = Food.where(:is_public => true)

    public_foods.each do |food|
      @foods_ids << food.id if food.support_days.include?(wday_now)
    end
    @foods_ids
  end

end
