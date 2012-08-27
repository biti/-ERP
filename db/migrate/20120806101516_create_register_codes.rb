class CreateRegisterCodes < ActiveRecord::Migration
  def change
    create_table :register_codes do |t|
      t.string :code
      t.boolean :is_available

      t.timestamps
    end
  end
end
