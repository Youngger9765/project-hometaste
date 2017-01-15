class AddCancelledReasonToOrders < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :cancelled_reason, :string
  end
end
