class CreateTableMonthCharts < ActiveRecord::Migration
  def up
    create_table :month_charts do |t|
      t.string  :month
      t.decimal :total_sales
      t.integer :total_orders
      t.integer :total_products
      t.integer :total_customers
      t.integer :total_new_customers
    end
    
  end

  def down
  end
end
