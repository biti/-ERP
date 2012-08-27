class AddMobileInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :mobile, :string
  end

  def down
  end
end
