class AddOuterIdInProducts < ActiveRecord::Migration
  def up
    add_column :products, :outer_id, :string
  end

  def down
  end
end
