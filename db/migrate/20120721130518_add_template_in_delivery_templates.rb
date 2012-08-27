class AddTemplateInDeliveryTemplates < ActiveRecord::Migration
  def up
    add_column :delivery_templates, :template, :string
    add_column :delivery_templates, :fields, :string
  end

  def down
  end
end
