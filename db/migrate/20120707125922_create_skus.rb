class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.integer :sku_id
      t.integer :product_id
      t.string :outer_id
      t.decimal :price
      t.string :properties
      t.integer :quantity

      t.timestamps
    end
  end
end
