class CreateUserPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :user_photos do |t|
    	t.integer 	:user_id
      t.timestamps
    end
  end
end
