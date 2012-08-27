class AddBindedInShops < ActiveRecord::Migration
  def up
    add_column :shops, :binded, :boolean
  end

  def down
  end
end
