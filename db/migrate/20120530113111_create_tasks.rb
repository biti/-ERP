class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.datetime :delivery_time
      t.integer :order_num
      t.integer :product_total

      t.timestamps
    end
  end
end
