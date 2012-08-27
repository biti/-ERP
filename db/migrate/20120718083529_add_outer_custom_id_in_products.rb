class AddOuterCustomIdInProducts < ActiveRecord::Migration
  def up
    add_column :products, :outer_custom_id, :string
    add_column :skus, :outer_custom_id, :string
  end

  def down
  end
end
