# encoding: utf-8
require 'spreadsheet'
require 'paipai'

class Order < ActiveRecord::Base

  DELIVERY_COMPANYS = [
    {
      :no => '10',
      :name => '圆通'
    },
  ]
    
  attr_accessor :file
  validates_presence_of :name

  belongs_to :user
  has_many :items, :class_name => 'OrderItem', :foreign_key => "order_id"
  
  # 友好的产品信息
  def human_products_info
    items.inject('') { |s, item| s += item.product_name }
  end
  
  def human_tel
    "#{mobile} #{phone}"
  end
  
  class << self
    
    def sync(current_user_id, shops)
      shops.each do |shop|
        platform = PLATFORMS.select{ |k, v| v[:id] == shop.platform_id}.first.first
        __send__("sync_from_#{platform}", current_user_id, shop)
      end
    end

    
    def sync_from_taobao(current_user_id, shop)
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )
      
      bought_orders = @top.trades_for(:sold_list, {:page_size => 100, :use_has_next => 'true'})
      
      bought_orders.each do |o|
        save_taobao_order(current_user_id, o)
      end
      
      if @top.has_next
        sync_from_taobao(current_user_id, shop)
      end
    end    
    
    def save_taobao_order(current_user_id, o)
      if Order.find_by_outer_id(o.tid)
        return
      end
      
      order = Order.new(
        :user_id => current_user_id, 
        :outer_id => o.tid,
        :status => PLATFORMS[:taobao][:status_mapping][o.status],
        :platform_id => PLATFORMS[:taobao][:id],
        :total => o.num,
        
        :user_outer_id => o.alipay_id,
        :buyer_nick => o.buyer_nick,
        :email => o.buyer_email,
                            
        :name => o.receiver_name,
        :state => o.receiver_state,
        :city => o.receiver_city,
        :district => o.receiver_district,
        :zip => o.receiver_zip,
        :address => o.receiver_address,
        :phone => o.receiver_phone,
        :mobile => o.receiver_mobile,
        :consign_time => o.consign_time,
        :buyer_message => o.buyer_message,
        
        :order_time => o.created,
        
        :total_fee => o.total_fee,
        :payment => o.payment
    	)
      
      transaction do
        order.save
      
        o.orders.each do |i|
          OrderItem.create(
            :order_id => order.id,
            :order_outer_id => order.outer_id,
            
            :product_name => i.title,
            :total_fee => i.total_fee,
            :payment => i.payment,

            :product_outer_id => i.num_iid,
            :sku_outer_id => i.sku_id,
            :sku_properties_name => i.sku_properties_name,
            :price => i.price,
            :quantity => i.num,
            
            :image_url => i.pic_path
          )
        end
      end
    end
    
    def sync_from_paipai(current_user_id, shop, page_index = 1)
      
      url = 'http://api.paipai.com/deal/sellerSearchDealList.xhtml'
      options = {
        'token' => shop.access_token,
        'spid' => shop.spid,
        'skey' => shop.skey,
        
        'cmdid' => 'deal.sellerSearchDealList',
        'charset' => 'utf-8',

        'pureData' => 1,
        'listItem' => 1,
        
        'pageIndex' => page_index,
        'pageSize' => 20,
        
        'uin' => shop.qq,
        'sellerUin' => shop.qq,
      }

      result = Paipai.get(url, options)
      logger.info "[paipai result]==========%s" % result
      
      result['dealList'].each do |item|
        save_paipai_order(current_user_id, item)
      end
      
      page_total = result['pageTotal'].to_i
      if page_total > page_index
        sync_from_paipai(current_user_id, shop, page_index + 1)
      end
    end

    def save_paipai_order(current_user_id, item)
      if Order.find_by_outer_id(item['dealCode'])
        return
      end
      
      order = Order.new(
        :user_id => current_user_id,
        :outer_id => item['dealCode'],
        :status => PLATFORMS[:paipai][:status_mapping][ item['dealState'] ],
        :platform_id => PLATFORMS[:paipai][:id],
        # :total => item[''].to_i,
        
        :user_outer_id => item['buyerUin'],
        :buyer_nick => item['buyerName'],
        
        :email => '',
                            
        :name => item['receiverName'],
        :state => '',
        :city => '',
        :district => '',
        :zip => item['receiverPostcode'],
        :address => item['receiverAddress'],
        :phone => item['receiverPhone'],
        :mobile => item['receiverMobile'],
        # :consign_time => '',
        :buyer_message => item['buyerRemark'],
        
        :order_time => item['createTime'],
        
        :total_fee => item['totalCash'],
        :payment => item['dealPayFeeTicket']
    	)
    	
    	transaction do
      	order.save        

      	item['itemList'].each do |i|
          OrderItem.create(
            :order_id => order.id,
            :order_outer_id => order.outer_id,
            
            :product_name => i['itemName'],
            # :total_fee => ,
            # :payment => ,

            :product_outer_id => i['itemCode'],
            :sku_outer_id => i['stockLocalCode'],
            :sku_properties_name => i['stockAttr'],
            :price => BigDecimal( i['itemDealPrice'] ) + BigDecimal( i['itemAdjustPrice'] ),
            :quantity => i['itemDealCount'].to_i,
            
            :image_url => i['itemPic80']
          )
        end
      end
    end
    
    def sync_from_jingdong(current_user_id, shop)
    end
    
    def import(order, file)
      book = Spreadsheet.open file.tempfile
      sheet1 = book.worksheet 0
      import_no = 0
      
      sheet1.each_with_index do |row, index|
        unless index == 0
          # 导过的不再导了
          if Order.find_by_order_no(row[9])
            next
          end
          
          o = Order.new do |o|
            o.delivery_no = row[1].to_i.to_s
            o.name = row[2]
            o.destination = row[3]
            o.address = row[4]
            o.phone = row[5]
            o.specification = row[6]
            o.total = row[7]
            o.delivery_company = row[8]
            o.order_no = row[9]
            o.delivery_info = row[10]
            o.order_time = row.at(11)
            
            o.platform = order[:platform]
          end
          
          o.save
          import_no += 1
        end
      end
      
      import_no
    end
    
    def shipping(params)
      params[:order].each do |o|
        logger.debug "=========%s" % o.inspect
        platform = PLATFORMS.select{ |k, v| v[:id] == o[:platform_id].to_i}.first.first  
        
        # 调用api发货
        __send__("#{platform}_shipping", o, params[:delivery_company])
        
        # 记录发货状态
        order = Order.find(o[:id])
        if order
          order.update_attribute :status, :seller_delivery
        end
      end
    end
    
    def taobao_shipping(order, delivery_company)
      shop = Shop.where(:platform_id => PLATFORMS[:taobao][:id]).first
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )
      
      company_code = LOGISTICS_COMPANIES.select{|k, v| k == delivery_company.to_sym}.values.first[:taobao_code]
      logger.debug "[taobao shipping] company_code=====%s" % company_code
      options = {
        :tid => order[:outer_id],
        :out_sid => order[:delivery_no],
        :company_code => company_code,
      }
      result = @top.logistics_offline_send(:send, options)
      logger.debug "[taobao shipping] result========%s" % result.inspect
    end
    
    def paipai_shipping(order, delivery_company)
      # Todo..
    end
    
    def jingdong_shipping(order, delivery_company)
      # Todo..
    end
    
    # 批量发货
    def update_ship_fee(params)
      ids = params[:ids].split(',')
      ship_fee = params[:ship_fee]
      
      Order.where(:id => ids).each do |order|
        platform = PLATFORMS.select{ |k, v| v[:id] == order.platform_id}.first.first
        
        # 调用api
        __send__("#{platform}_update_ship_fee", order, ship_fee)
        
        # 本地记录
        order.update_attributes(:ship_fee => ship_fee)
      end
    end
    
    def taobao_update_ship_fee(order, ship_fee)
      shop = Shop.where(:platform_id => PLATFORMS[:taobao][:id]).first
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )
      
      options = {
        :tid => order.outer_id,
        :post_fee => ship_fee,
      }
      result = @top.update_ship_fee(options)
      logger.info "[taobao update_ship_fee] result========%s" % result.inspect
      
      order.update_attributes(
        :ship_fee => BigDecimal(ship_fee), 
        :payment => BigDecimal(result.payment), 
        :total_fee => BigDecimal(result.total_fee)
      )
      order
    end
    
    def paipai_update_ship_fee(order, ship_fee)
      
    end
  end
  
  def human_status
    case status
    when 'wait_buyer_pay'
      '等待买家付款'
    when ''
    end
  end

  def human_address
    """
    收件人：#{name} 
    电话：#{mobile}, #{phone} 
    邮编：#{zip} 
    地址：#{state} #{city} #{district} #{address}
    """
  end
  
  def human_address_bak
    """
    收件人：#{name}<br/>
    电话：#{mobile} #{phone}<br/>
    邮编：#{zip}<br/>
    地址：#{state} #{city} #{district} #{address} xxxxxxx<br/>
    """
  end
  
  
end


