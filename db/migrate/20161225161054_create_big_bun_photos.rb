class CreateBigBunPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :big_bun_photos do |t|
    	t.integer	:big_bun_id, :index => true
      t.timestamps
    end
  end
end
