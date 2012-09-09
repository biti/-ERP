# encoding: utf-8
require 'spreadsheet'
require 'paipai'

class Order < ActiveRecord::Base

  STATUS = {
    :waiting_pay => {
      :value => 10,
      :text  => '等待付款',
    },
    :paid => {
      :value => 20,
      :text  => '已付款，等待发货',
    },
    :shipped => {
      :value => 30,
      :text  => '已发货，等待签收',
    },
    :received => {
      :value => 40,
      :text  => '已收到货物',
    },
    :completed => {
      :value => 50,
      :text  => '订单成功',
    },
  }
  
  validates_presence_of :name

  belongs_to :subscriber
  has_many :items, :class_name => 'OrderItem', :foreign_key => "order_id"
  
  # 友好的产品信息
  def human_products_info
    items.inject('') { |s, item| s += item.product_name }
  end
  
  def human_tel
    "#{mobile} #{phone}"
  end

  def human_status
    STATUS.values.find{|item| item[:value] == status}[:text]
  end

  def human_address
    """
    收件人：#{name} 
    电话：#{mobile}, #{tel} 
    邮编：#{zip} 
    地址：#{state} #{city} #{district} #{address}
    """
  end  
  
  class << self

    def shipping(orders)
    end
    
  end
  
  
end


