class AddColumnsInUsers < ActiveRecord::Migration
  def up
    
    add_column :users, :realname, :string
    add_column :users, :permissions, :string
  end

  def down
  end
end
