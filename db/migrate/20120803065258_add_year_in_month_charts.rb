class AddYearInMonthCharts < ActiveRecord::Migration
  def up
    add_column :month_charts, :year, :integer
    change_column :month_charts, :month, :integer
  end

  def down
  end
end
