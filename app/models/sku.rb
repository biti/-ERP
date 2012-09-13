# encoding: utf-8

class Sku < ActiveRecord::Base

  validates_presence_of :custom_id
  validates_uniqueness_of :custom_id, :scope => :product_id
  validates_numericality_of :price, :greater_than => 0, :message => '必须是大于0的数字'
  validates_numericality_of :num, :greater_than => 0, :message => '必须是大于0的数字'
  
  belongs_to :product, :class_name => 'Product', :foreign_key => 'product_id'  
  has_many :stocks
  
  def value_0
    return '' if specification.blank?
    JSON.parse(specification).find{ |item| item['property'] == '颜色' }['value']
  end

  def value_1
    return '' if specification.blank?
    JSON.parse(specification).find{ |item| item['property'] == '尺码' }['value']
  end

end
