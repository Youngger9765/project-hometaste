class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name,         null: false, default: ""

      t.timestamps
    end
  end
end
