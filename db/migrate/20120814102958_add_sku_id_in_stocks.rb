class AddSkuIdInStocks < ActiveRecord::Migration
  def up
    add_column :stocks, :sku_id, :integer
    add_index :stocks, :sku_id
  end

  def down
  end
end
