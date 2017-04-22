class AddGiverIdToUserBigbunShips < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_big_bun_ships, :giver_id, :integer, :index => true
  end
end
