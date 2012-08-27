class CreateCustomerLevels < ActiveRecord::Migration
  def change
    create_table :customer_levels do |t|
      t.string :name
      t.decimal :total_amount
      t.integer :total_orders

      t.timestamps
    end
  end
end
