class CreateStateTaxRateShips < ActiveRecord::Migration[5.0]
  def change
    create_table :state_tax_rate_ships do |t|
    	t.string	:state, :index => true
    	t.float		:tax_rate
      t.timestamps
    end
  end
end
