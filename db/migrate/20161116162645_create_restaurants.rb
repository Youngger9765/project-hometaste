class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
    	t.string :name,         null: false, default: ""
      t.string :address, 			null: false, default: ""
      t.string :phone_number, null: false, default: ""
      t.text :description
      t.timestamps
    end
  end
end
