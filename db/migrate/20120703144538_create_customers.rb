class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.decimal :total_amount
      t.integer :total_orders
      t.integer :level

      t.timestamps
    end
  end
end
