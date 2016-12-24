class ChangeAmountToOrders < ActiveRecord::Migration[5.0]
  def change
  	change_column :order_food_ships, :quantity, :decimal, precision: 10, scale: 2
  	change_column :order_food_ships, :amount, :decimal, precision: 10, scale: 2

  	change_column :orders, :amount, :decimal, precision: 10, scale: 2

  	change_column :foods, :price, :decimal, precision: 10, scale: 2
  end
end
