class AddPhotoToRestaurantDishPhoto < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :restaurant_dish_photos, :photo
  end
end
