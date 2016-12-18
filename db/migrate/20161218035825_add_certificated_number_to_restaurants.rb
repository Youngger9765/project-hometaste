class AddCertificatedNumberToRestaurants < ActiveRecord::Migration[5.0]
  def change
  	add_column :restaurants, :certificated_num, :string
  end
end
