class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :delivery_no
      t.string :order_no
      t.string :platform
      t.string :name
      t.string :destination
      t.string :address
      t.integer :total
      t.string :specification
      t.string :delivery_company
      t.string :delivery_info
      t.string :remark
      t.datetime :order_time
      
      t.timestamps
    end
    
  end

  def self.down
    drop_table :orders
  end
end
