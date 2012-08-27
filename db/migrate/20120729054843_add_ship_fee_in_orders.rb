class AddShipFeeInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :ship_fee, :decimal
  end

  def down
  end
end
