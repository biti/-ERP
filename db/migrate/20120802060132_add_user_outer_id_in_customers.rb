class AddUserOuterIdInCustomers < ActiveRecord::Migration
  def up
    add_column :customers, :user_outer_id, :string
    add_column :customers, :user_id, :integer
  end

  def down
  end
end
