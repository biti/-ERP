class AddUserOuterIdInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :user_outer_id, :string
  end

  def down
  end
end
