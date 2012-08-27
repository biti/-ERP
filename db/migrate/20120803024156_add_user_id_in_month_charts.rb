class AddUserIdInMonthCharts < ActiveRecord::Migration
  def up
    add_column :month_charts, :user_id, :integer
    add_index :month_charts, :user_id
  end

  def down
  end
end
