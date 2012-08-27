class AddPlatformIdInAccounts < ActiveRecord::Migration
  def up
    add_column :shops, :platform_id, :integer
    add_column :shops, :user_id, :integer
  end

  def down
  end
end
