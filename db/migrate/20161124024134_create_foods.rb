class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.integer :restaurant_id,null: false
      t.string :name,         null: false, default: ""
      t.integer :price,       null: false, default: 0

      t.timestamps
    end
  end
end
