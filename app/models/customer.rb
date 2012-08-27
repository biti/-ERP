# encoding: utf-8

class Customer < ActiveRecord::Base

  has_many :contacts
  belongs_to :user
  
  LEVELS = {
    1 => {
      :name => '普通客户',
      :color => '',
    },
    2 => {
      :name => '高级客户',
      :color => 'green',
    },
    3 => {
      :name => 'VIP客户',
      :color => 'red',
    },
    4 => {
      :name => '至尊VIP客户',
      :color => 'orange',
    },
  }

  before_save do |customer|
    CustomerLevel.order('level').limit(LEVELS.size).each do |l|
      if customer.total_amount >= l.total_amount or customer.total_orders >= l.total_orders
        customer.level = l.level
      end
    end
  end
  
  def human_level
    "<span style='color:#{LEVELS[level.to_i][:color]}'>#{LEVELS[level.to_i][:name]}</span>"
  end
  
  # 是否已经记录过这个订单的地址？
  def recorded_address?(order)
    contacts.each do |contact|
      return true if contact.human_address == order.human_address
    end
    
    false
  end

  class << self
        
    def init_from_orders(current_user_id)
      Order.where(:user_id => current_user_id).find_each(:batch_size => 2000) do |order|
        customer = Customer.find_by_user_outer_id(order.user_outer_id)
        
        if customer
          customer.total_amount = customer.total_amount + order.payment
          customer.total_orders = customer.total_orders + 1
        else
          customer = Customer.new(
            :user_id => current_user_id,
            :user_outer_id => order.user_outer_id,
            :total_amount => order.payment,
            :total_orders => 1,
            :platform_id => order.platform_id
          )
        end
        
        customer.save
        
        unless customer.recorded_address?(order)
          Contact.create(
            :user_id => current_user_id,
            :customer_id => customer.id,
            :name => order.name,
            :mobile => order.mobile,
            :phone => order.phone,
            :email => order.email,
            :state => order.state,
            :city => order.city,
            :district => order.district,
            :zip => order.zip,
            :address => order.address
          )
        end
      end
    end
    
  end
end
