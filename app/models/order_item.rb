class OrderItem < ActiveRecord::Base
  
  belongs_to :order, :class_name => 'Order', :foreign_key => "order_id"
  
  def human_specification
    JSON.parse(sku_specification).map { |item| "#{item['property']}:#{item['value']}" }.join(',')
  end
  
end