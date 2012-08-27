class AddNumSellInProduts < ActiveRecord::Migration
  def up
    add_column :products, :num_sell, :integer
  end

  def down
  end
end
