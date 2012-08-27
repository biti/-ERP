class AddPriceBodyInProduts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.integer :num
      t.decimal :cost_price
    end
    
  end

  def down
  end
end
