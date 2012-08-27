class AddRegisterCodeInUsers < ActiveRecord::Migration
  def up
    add_column :users, :salt, :string
    add_column :users, :phone, :string
    add_column :users, :register_code, :string
  end

  def down
  end
end
