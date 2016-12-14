class AddGoogleInfoToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :google_uid, :string
    add_index  :users, :google_uid
    add_column :users, :google_token, :string
    add_column :users, :google_raw_data, :text
    add_column :users, :google_email, :string
    add_column :users, :google_name, :string
    add_column :users, :google_head_shot, :string
  end
end
