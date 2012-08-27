class AddPlatformIdInCustomers < ActiveRecord::Migration
  def up
    add_column :customers, :platform_id, :integer
  end

  def down
  end
end
