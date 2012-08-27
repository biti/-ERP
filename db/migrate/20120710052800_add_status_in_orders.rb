class AddStatusInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :status, :string
  end

  def down
  end
end
