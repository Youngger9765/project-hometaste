class Food < ApplicationRecord

  belongs_to :restaurant

  has_many :order_food_ships
  has_many :orders, :through => :order_food_ships

  has_many :food_comments
  has_many :food_photos

  accepts_nested_attributes_for :food_photos,
    :allow_destroy => true,
    :reject_if => :all_blank

  def average_score
    food_comments.average(:score) || 0
  end

  def self.filter( params , lat_long, ids = self.ids )
    sort = params['Sort By']
    distance = params['Distance']
    price = params['Price']
    # cuisine = params['Cuisine']
    features = params['Features']

    where(id:ids).filter_distance(distance,lat_long)
        .filter_features(features)
        .filter_price(price)
        .filter_sort(sort)
        # .filter_cuisine(cuisine)
  end

  def self.filter_price( _case )
    case _case[0]
    when '$'    ; where('price < ?',10)
    when '$$'   ; where('price >= ? and price < ?',11,30)
    when '$$$'  ; where('price >= ? and price < ?',31,60)
    when '$$$$' ; where('price > ? ',60)
    end
  end

  def self.filter_features( _case )
    foods = self.joins(:restaurant)
    foods = foods.where(:is_public => true) if _case.include?("Today's Meal")
    foods = foods.where('restaurants.id = ?',Delivery.ids) if _case.include?('Delivery')
    foods = foods.where('restaurants.id = ?',BulkBuy.ids) if _case.include?('Bulk Buy')
    if _case.include?('Offer BigBun')
      restaurant_ids = BigBun.where(:is_public => true).pluck(:restaurant_id).uniq
      foods = foods.where('restaurants.id = ?',restaurant_ids)
    end
    foods
  end

  def self.filter_distance( _case , coordinate )
    lat, long = coordinate
    km = case _case[0]
         when 'Driving-5min' ; 2
         when 'Biking-5min'  ; 1
         when 'Walking-1min' ; 0.1
         else                ; _case[0].to_i * 0.1
         end
    km = 100 if km == 0
    restaurant_ids = Restaurant.get_around_restaurants( km , lat , long ).ids
    where(restaurant_id:restaurant_ids)
  end

  def self.filter_sort( _case )
    case _case[0]
    when 'BestMatch'        ; self.all
    when 'Highest Rated'    ; joins(:restaurant).order('restaurants.food_avg_score desc')
    when 'Most Reviewed'    ; joins(:restaurant).order('restaurants.food_comments_count desc')
    when 'New'              ; order('updated_at desc')
    end
  end

  def self.filter_cuisine( _case )
    if _case.include?('Any Cuisine')
      self.all
    else
      _cases = _case.uniq
      _cases = _case.map {|x| "%#{ x.to_s.split(' ')[0].to_s.gsub(/[^a-zA-Z0-9\-]/,'') }%" }
      cuisine_ids = _cases.map {|x|  Cuisine.where('name like ?',x).ids}.flatten
      restaurant_id = RestaurantCuisineShip.where(cuisine_id:cuisine_ids).pluck(:restaurant_id)
      Restaurant.where(id:restaurant_id)
    end
  end
end


