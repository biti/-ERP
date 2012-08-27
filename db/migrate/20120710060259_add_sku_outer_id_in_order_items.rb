class AddSkuOuterIdInOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :sku_outer_id, :string
  end

  def down
  end
end
