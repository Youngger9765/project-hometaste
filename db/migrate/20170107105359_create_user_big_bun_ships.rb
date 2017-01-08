class CreateUserBigBunShips < ActiveRecord::Migration[5.0]
  def change
    create_table :user_big_bun_ships do |t|
    	t.integer	:big_bun_id, :index => true
    	t.integer	:user_id, :index => true
    	t.string	:order_id, :index => true
    	t.string	:usage
    	t.boolean	:is_used, :default => false

      t.timestamps
    end
  end
end
