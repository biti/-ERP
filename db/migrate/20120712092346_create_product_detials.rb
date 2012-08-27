class CreateProductDetials < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.text :body
      t.integer :product_id

      t.timestamps
    end
  end
end
