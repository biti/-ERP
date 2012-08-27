class CreateDayData < ActiveRecord::Migration
  def change
    create_table :day_data do |t|
      t.integer :user_id
      t.integer :year
      t.integer :month
      t.integer :day
      t.decimal :total_sales
      t.integer :total_orders
      t.integer :total_products
      t.integer :total_customers
      t.integer :total_new_customers

      t.timestamps
    end
  end
end
