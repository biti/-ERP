class AddPriceInProducts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.column :price, :decimal
      t.column :status, :integer
      t.column :image_url, :string
      t.column :detail_url, :string
    end
  end

  def down
  end
end
