class AddMainPhotoToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :restaurants, :main_photo
  end
end
