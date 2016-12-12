class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
    	t.datetime	:scheduled_time
    	t.integer 	:user_id
    	t.integer 	:restaurant_id
    	t.string		:customer_name
      t.string		:shipping_method
      t.text			:shipping_place
      t.string		:shipping_status
      t.decimal		:amount
      t.string		:payment_method
      t.string		:payment_status,			null: false, default: "pendeing"
      t.string		:order_status
      t.timestamps
    end
  end
end