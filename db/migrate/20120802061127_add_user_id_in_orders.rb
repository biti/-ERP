class AddUserIdInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :user_id, :integer
    add_column :products, :user_id, :integer
  end

  def down
  end
end
