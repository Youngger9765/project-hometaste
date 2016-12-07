class AddIsLiveToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :is_live, :boolean, default: true
  end
end
