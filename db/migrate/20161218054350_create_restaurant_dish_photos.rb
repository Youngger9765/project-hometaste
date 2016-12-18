class CreateRestaurantDishPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurant_dish_photos do |t|
    	t.integer	:restaurant_id, :index => true
    	t.text	:comment
      t.timestamps
    end
  end
end
