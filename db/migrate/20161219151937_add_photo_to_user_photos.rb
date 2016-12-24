class AddPhotoToUserPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :user_photos, :photo
  end
end
