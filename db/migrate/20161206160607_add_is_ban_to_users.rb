class AddIsBanToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :is_ban, :boolean, default: false
  end
end
