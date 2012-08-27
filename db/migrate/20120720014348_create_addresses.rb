class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :email
      t.string :state
      t.string :city
      t.string :district
      t.string :zip
      t.string :mobile
      t.string :phone
      t.string :detail

      t.timestamps
    end
  end
end
