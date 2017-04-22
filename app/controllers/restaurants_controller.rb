class RestaurantsController < ApplicationController

  before_action :find_restaurant, :except => [:index]
  before_action :find_chef, :except => [:index]
  before_action :get_today_foods_ids, :except => [:index]

  def index
    @user = User.new
  end

  def show
    @user = current_user || User.new

    time_range = (Time.now.localtime.beginning_of_day().utc..Time.now.localtime.end_of_day().utc)
    @today_orders = @chef.restaurant.orders.where(:payment_status => "paid").where(:pick_up_time => time_range)

    if @restaurant.order_reach > 0
      @reach_percent = (@today_orders.sum(:amount)*100/@restaurant.order_reach).to_f
    else
      @reach_percent = 0
    end

    # show today & advance foods
    wday_now = Time.now.localtime.wday

    @today_foods_ids = get_today_foods_ids
    @today_foods = Food.where(id:@today_foods_ids)


    # advance 的 example
    @date = deal_params_date(params[:date])
    @advance_foods_ids = get_in_advance_foods_ids(@date)
    @advance_foods = Food.where(id: @advance_foods_ids)

    # score_rate_i = @restaurant.food_avg_summary_score.to_i
    # score_rate_f = ((@restaurant.food_avg_summary_score - score_rate_i)/0.5).to_i
    # @score_rate = score_rate_i.to_s + ("_5" * score_rate_f)

    array = []
    if @restaurant.get_available_bigbun
      # 剩下的可用的bigbun 數量
      left_num = @restaurant.get_available_bigbun.availible_num
      array << [@restaurant, @restaurant.get_available_bigbun, left_num]
    end
    @restaurant_available_bigbun_array = array


    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def deal_params_date(params)
    params.to_time.strftime('%F')
  rescue
    Date.current.to_time.strftime('%F')
  end

  def find_restaurant
    @restaurant = Restaurant.includes(:big_buns,:bulk_buys).find(params[:id])
  end

  def find_chef
    @chef = @restaurant.chef
  end

  def get_today_foods_ids
    wday_now = Time.now.localtime.wday
    today_foods_ids = []
    public_foods = @restaurant.foods.where(:is_public => true)

    public_foods.each do |food|
      today_foods_ids << food.id if food.support_days.include?(wday_now)
    end

    today_foods_ids
  end

  def get_in_advance_foods_ids(date)
    wday = date.to_time.localtime.wday
    advance_foods_ids = []
    public_foods = @restaurant.foods.where(:is_public => true)

    public_foods.each do |food|
      advance_foods_ids << food.id if food.support_days.include?(wday)
    end

    advance_foods_ids
  end

end
