class ChangeNameToUsers < ActiveRecord::Migration[5.0]
  def change
  	rename_column :users, :user_name, :foodie_id
  end
end
