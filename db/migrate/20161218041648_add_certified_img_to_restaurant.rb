class AddCertifiedImgToRestaurant < ActiveRecord::Migration[5.0]
  def change
  	 add_attachment :restaurants, :certificated_img
  end
end
