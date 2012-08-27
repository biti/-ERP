class AddTotalFeeInOrders < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.string :outer_id
      
      t.string :buyer_message
      t.string :buyer_email

      t.string :state
      t.string :city
      t.string :district
      t.string :zip
      
      t.datetime :consign_time
            
      
    end
  end

  def down
  end
end
