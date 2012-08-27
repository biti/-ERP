class AddImageUrlInOrderItems < ActiveRecord::Migration
  def up
    add_column :order_items, :image_url, :string
  end

  def down
  end
end
