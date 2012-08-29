# encoding: utf-8

class Sku < ActiveRecord::Base
  
  belongs_to :product, :class_name => 'Product', :foreign_key => 'product_id'
  
  has_many :stocks
  
  def color
    return '' if specification.blank?
    JSON.parse(specification).find{ |item| item['property'] == '颜色' }['value']
  end

  def size
    return '' if specification.blank?
    JSON.parse(specification).find{ |item| item['property'] == '尺码' }['value']
  end
  
end
