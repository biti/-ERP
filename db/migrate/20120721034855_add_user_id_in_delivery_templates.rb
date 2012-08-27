class AddUserIdInDeliveryTemplates < ActiveRecord::Migration
  def up
    add_column :delivery_templates, :user_id, :integer
  end

  def down
  end
end
