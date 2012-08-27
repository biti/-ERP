class AddUserIdInSkus < ActiveRecord::Migration
  def up
    add_column :skus, :user_id, :integer
    
    add_index :skus, :user_id
  end

  def down
  end
end
