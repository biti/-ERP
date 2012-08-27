class AddFilePathInOrders < ActiveRecord::Migration
  def up
    add_column :orders, :file_path, :string
  end

  def down
  end
end
