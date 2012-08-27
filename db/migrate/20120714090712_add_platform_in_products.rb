class AddPlatformInProducts < ActiveRecord::Migration
  def up
    add_column :products, :platform_id, :integer
  end

  def down
  end
end
