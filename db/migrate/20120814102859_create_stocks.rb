class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :platform_id
      t.integer :num
      t.integer :min

      t.timestamps
    end
  end
end
