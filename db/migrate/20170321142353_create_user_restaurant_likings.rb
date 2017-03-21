class CreateUserRestaurantLikings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_restaurant_likings do |t|
    	t.integer :user_id, :index => true
    	t.integer :restaurant_id, :index => true
      t.timestamps
    end
  end
end
