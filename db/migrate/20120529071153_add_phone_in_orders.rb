class AddPhoneInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :phone, :string
  end

  def down
  end
end
