class Food < ApplicationRecord

  belongs_to :restaurant

  has_many :order_food_ships
  has_many :orders, through: :order_food_ships

  has_many :food_comments
  has_many :food_photos

  has_many :food_cuisine_ships
  has_many :cuisines, through: :food_cuisine_ships

  has_many :user_food_likings
  has_many :liking_users , :source => :user, :through => :user_food_likings

  accepts_nested_attributes_for :food_photos,
                                :allow_destroy => true,
                                :reject_if => :all_blank

  accepts_nested_attributes_for :food_cuisine_ships,
                                :allow_destroy => true,
                                :reject_if => :all_blank

  serialize :support_days

  def average_score
    score = food_comments.average(:summary_score) || 0
    score = score.round(1)
    if score.to_s[-1].to_i >= 5
      (score.to_s[0].to_i + 1).to_i
    elsif score.to_s[-1].to_i > 0
      score.to_i + 0.5
    else
      score.to_i
    end
  end

  def self.today_foods(foods_ids)
    where(:id => foods_ids)
  end

  def get_available_bigbun
    restaurant.get_available_bigbun
  end

  def self.filter(params, lat_long, ids = self.ids)
    sort = params['Sort By']
    distance = params['Distance']
    price = params['Price']
    cuisine = params['Cuisine']
    features = params['Features']

    where(id:ids).filter_distance(distance,lat_long)
        .filter_features(features)
        .filter_price(price)
        .filter_sort(sort)
        .filter_cuisine(cuisine)
  end

  def self.filter_price(_case)
    case _case[0]
    when '$'    then where('price < ?',10)
    when '$$'   then where('price >= ? and price < ?',11,30)
    when '$$$'  then where('price >= ? and price < ?',31,60)
    when '$$$$' then where('price > ? ',60)
    end
  end

  def self.filter_features(_case)
    foods = self.joins(:restaurant)
    foods = foods.where(:is_public => true) if _case.include?("Today's Meal")
    foods = foods.where('restaurants.id = ?',Delivery.ids) if _case.include?('Delivery')
    foods = foods.where('restaurants.id = ?',BulkBuy.ids) if _case.include?('Bulk Buy')
    if _case.include?('Offer BigBun')
      restaurant_ids = BigBun.where(is_public: true).pluck(:restaurant_id).uniq
      foods = foods.where('restaurants.id = ?',restaurant_ids)
    end
    foods
  end

  def self.filter_distance(_case, coordinate)
    lat, long = coordinate
    km = case _case[0]
         when 'Driving-5min' then 2
         when 'Biking-5min'  then 1
         when 'Walking-1min' then 0.1
         else
           _case[0].to_i * 0.1
         end
    km = 10 if km == 0
    restaurant_ids = Restaurant.get_around_restaurants(km, lat, long).ids
    where(restaurant_id:restaurant_ids)
  end

  def self.filter_sort(_case)
    case _case.first
    when 'BestMatch'        then all
    when 'Highest Rated'    then joins(:restaurant).order('restaurants.food_avg_summary_score desc')
    when 'Most Reviewed'    then joins(:restaurant).order('restaurants.food_comments_count desc')
    when 'New'              then order('updated_at desc')
    end
  end

  def self.filter_cuisine(_case)
    if _case.include?('Any Cuisine')
      all
    else
      _cases = _case.uniq
      _cases = _case.map { |x| "%#{ x.to_s.split(' ')[0].to_s.gsub(/[^a-zA-Z0-9\-]/,'') }%" }
      cuisine_ids = _cases.map { |x| Cuisine.where('name like ?', x).ids }.flatten
      food_id = FoodCuisineShip.where(cuisine_id: cuisine_ids).pluck(:food_id)
      where(id: food_id)
    end
  end
end


