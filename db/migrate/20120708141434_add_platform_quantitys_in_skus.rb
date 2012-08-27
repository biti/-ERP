class AddPlatformQuantitysInSkus < ActiveRecord::Migration
  def up
    add_column :skus, :platform_quantities, :string
  end

  def down
  end
end
