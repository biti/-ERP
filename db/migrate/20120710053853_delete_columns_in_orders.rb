class DeleteColumnsInOrders < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.remove :order_no, :specification, :remark, :file_path
      t.rename :buyer_email, :email
    end
  end

  def down
  end
end
