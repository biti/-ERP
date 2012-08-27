class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :customer_id
      t.string :loginname
      t.string :nickname
      t.string :name
      t.string :mobile
      t.string :phone
      t.string :email
      t.string :qq
      t.string :state
      t.string :city
      t.string :district
      t.string :zip
      t.string :address

      t.timestamps
    end
  end
end
