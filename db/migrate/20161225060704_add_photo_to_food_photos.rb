class AddPhotoToFoodPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :food_photos, :photo
  end
end
