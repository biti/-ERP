class AddSpidInAccounts < ActiveRecord::Migration
  def up
    add_column :shops, :spid, :string
    add_column :shops, :skey, :string
  end

  def down
  end
end
