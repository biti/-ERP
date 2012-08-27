class AddUserIdInContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :user_id, :integer
  end

  def down
  end
end
