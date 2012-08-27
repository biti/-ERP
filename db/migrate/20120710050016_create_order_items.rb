class CreateOrderItems < ActiveRecord::Migration
  def up
    create_table :order_items do |t|
      t.integer :order_id
      t.string :order_outer_id
      
      t.integer :product_id
      t.string :product_outer_id
      
      t.string :sku_id
      t.string :sku_properties_name
      
      t.integer :quantity
      t.decimal :price
    end
  end

  def down
  end
end
