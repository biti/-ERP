class AddLevelInCustomerLevels < ActiveRecord::Migration
  def up
    add_column :customer_levels, :level, :integer
  end

  def down
  end
end
