class AddNumIidInProducts < ActiveRecord::Migration
  def up
    add_column :products, :num_iid, :integer
  end

  def down
  end
end
