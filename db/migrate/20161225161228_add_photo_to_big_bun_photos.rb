class AddPhotoToBigBunPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :big_bun_photos, :photo
  end
end
