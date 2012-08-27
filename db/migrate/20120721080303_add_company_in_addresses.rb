class AddCompanyInAddresses < ActiveRecord::Migration
  def up
    add_column :addresses, :company, :string
  end

  def down
  end
end
