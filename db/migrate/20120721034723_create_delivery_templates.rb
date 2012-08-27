class CreateDeliveryTemplates < ActiveRecord::Migration
  def change
    create_table :delivery_templates do |t|
      t.string :name
      t.string :company
      t.string :image_url
      t.integer :width
      t.integer :height
      t.string :options

      t.timestamps
    end
  end
end
