class AddDefaultInDeliveryTemplates < ActiveRecord::Migration
  def up
    add_column :delivery_templates, :default, :boolean
  end

  def down
  end
end
