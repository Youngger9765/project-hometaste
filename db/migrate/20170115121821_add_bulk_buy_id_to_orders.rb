class AddBulkBuyIdToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :bulk_buy_id, :integer
  end
end
