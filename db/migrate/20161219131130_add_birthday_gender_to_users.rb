class AddBirthdayGenderToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :gender, :string
  	add_column :users, :birthday, :date
  	add_column :users, :ZIP, :string
  end
end
