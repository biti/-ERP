class AddProductNameInOrderItems < ActiveRecord::Migration
  def up
    change_table :order_items do |t|
      t.string :product_name
      t.decimal :total_fee
      t.decimal :payment
    end
  end

  def down
  end
end
