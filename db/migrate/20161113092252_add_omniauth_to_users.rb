class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :fb_uid, :string
    add_index  :users, :fb_uid
    add_column :users, :fb_token, :string
    add_column :users, :fb_raw_data, :text
    add_column :users, :fb_email, :string
    add_column :users, :fb_name, :string
    add_column :users, :fb_head_shot, :string
  end
end
