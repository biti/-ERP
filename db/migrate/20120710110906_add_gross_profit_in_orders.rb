class AddGrossProfitInOrders < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.decimal :gross_profit
      t.decimal :total_fee
      t.decimal :payment
    end
  end

  def down
  end
end
