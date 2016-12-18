class CreateChefs < ActiveRecord::Migration[5.0]
  def change
    create_table :chefs do |t|
    	t.integer		:user_id,      	null: false
    	t.string		:first_name
    	t.string		:last_name
    	t.string		:phone_number
    	t.date			:birthday
    	t.string		:SSN
    	t.string		:routing_number
    	t.string		:account_number
      t.timestamps
    end
    add_index  :chefs, :user_id
  end
end
