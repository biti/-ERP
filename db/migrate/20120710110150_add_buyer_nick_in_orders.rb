class AddBuyerNickInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :buyer_nick, :string
  end

  def down
  end
end
