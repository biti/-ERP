class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :access_token
      t.string :shop_name
      t.string :shop_id

      t.timestamps
    end
  end
end
