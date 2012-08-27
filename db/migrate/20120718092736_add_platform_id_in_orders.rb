class AddPlatformIdInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :platform_id, :integer
  end

  def down
  end
end
