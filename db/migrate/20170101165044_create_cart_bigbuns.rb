class CreateCartBigbuns < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_bigbuns do |t|
    	t.integer	:cart_id, :index => true
    	t.integer	:big_bun_id, :index => true
    	t.integer	:quatity, :default => 1
      t.timestamps
    end
  end
end
