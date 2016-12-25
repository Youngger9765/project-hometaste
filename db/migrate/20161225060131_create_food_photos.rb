class CreateFoodPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :food_photos do |t|
      t.integer	:food_id, :index => true
      t.timestamps
    end
  end
end
