class AddQqInAccounts < ActiveRecord::Migration
  def up
    add_column :shops, :qq, :string
    add_column :shops, :top_session, :string
    add_column :shops, :top_parameters, :string
  end

  def down
  end
end
