class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
