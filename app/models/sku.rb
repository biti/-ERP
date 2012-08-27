# encoding: utf-8

class Sku < ActiveRecord::Base
  
  belongs_to :product, :class_name => 'Product', :foreign_key => 'product_id'
  
  has_many :stocks
  
end
