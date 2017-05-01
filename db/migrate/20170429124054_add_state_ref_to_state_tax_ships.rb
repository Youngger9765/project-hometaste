class AddStateRefToStateTaxShips < ActiveRecord::Migration[5.0]
  def change
  	add_column :state_tax_rate_ships, :state_ref, :string, :index => true
  end
end
