class AddSupportDaysToFoods < ActiveRecord::Migration[5.0]
  def change
  	add_column :foods , :support_days, :text, array:true
  end
end
