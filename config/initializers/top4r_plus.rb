# -*- encoding : utf-8 -*-
module Top4R
  
  # Sku Model
  class Sku
    include ModelMixin
    @@ATTRIBUTES = [:id, :sku_id, :num_iid, :iid, :properties, :properties_name, :quantity, :price, :outer_id, :created, :modified, :status]
    attr_accessor *@@ATTRIBUTES
    
    class << self
      def attributes; @@ATTRIBUTES; end
      
      def default_public_fields
        ['id', 'sku_id', 'num_iid', :properties_name, 'quantity', 'price', 'outer_id', 'status']
      end
    end
    
    def unmarshal_other_attrs
      @id = @sku_id
    end
  end
  
  # Trade model
  class Trade
    @@ATTRIBUTES = [:id, :seller_nick, :buyer_nick, :title, :type, :created, :iid, :price, 
      :pic_path, :num, :tid, :buyer_message, :shipping_type, :alipay_no, :payment, :sid, 
      :discount_fee, :adjust_fee, :snapshot_url, :snapshot, :status, :seller_rate, :buyer_rate, 
      :buyer_memo, :seller_memo, :trade_memo, :pay_time, :end_time, :modified, :buyer_obtain_point_fee, 
      :point_fee, :real_point_fee, :total_fee, :post_fee, :buyer_alipay_no, :receiver_name,
      :receiver_state, :receiver_city, :receiver_district, :receiver_address, :receiver_zip, 
      :receiver_mobile, :receiver_phone, :consign_time, :buyer_email, :commission_fee, 
      :seller_alipay_no, :seller_mobile, :seller_phone, :seller_name, :seller_email, 
      :available_confirm_fee, :has_post_fee, :received_payment, :cod_fee, :timeout_action_time, 
      :is_3D, :buyer_flag, :seller_flag, :num_iid, :promotion, :promotion_details, :invoice_name, :orders, 
      :alipay_id]
    attr_accessor *@@ATTRIBUTES
    
    class << self
      
      def default_public_fields
        ['receiver_name', 'receiver_email', "receiver_zip", "receiver_state", 'receiver_city', 
          'receiver_district', 'receiver_address',
          'alipay_id',
          'receiver_phone', 'receiver_mobile', 'consign_time', 'buyer_message', 
          'num', "tid", "modified", "title", "type", "status", "created", "price", 
          "sid", "pic_path", "iid", "payment", "alipay_no", "shipping_type", "pay_time", "end_time", 
          "orders"] + Top4R::Order.default_public_fields
      end
    end
    
  end
  

  class LogisticCompany

    @@ATTRIBUTES = [:id, :code, :name, :reg_mail_no]
    attr_accessor *@@ATTRIBUTES
    
    class << self
      def attributes; @@ATTRIBUTES; end
      
      def default_public_fields
        ["id", "code", "name", "reg_mail_no"]
      end
    end
  end
end


class Top4R::Client

  @@ITEM_METHODS = {
    :onsale_list => 'taobao.items.onsale.get',
    :inventory_list => 'taobao.items.inventory.get',
    :items_list => 'taobao.items.list.get',
    :item => 'taobao.item.get',

    :item_skus_get => 'taobao.item.skus.get',
    :skus_quantity_update => 'taobao.skus.quantity.update',
    
    :item_update_listing => 'taobao.item.update.listing',
    :item_update_delisting => 'taobao.item.update.delisting',
  }
  
  # 根据item id获取sku
  # 参数:
  #   num_iid  商品数字id
  def item_skus_get(num_iids, options = {})
    method = :item_skus_get
    valid_method(method, @@ITEM_METHODS, :item)
    options = {:num_iids => num_iids}
    params = {:fields => (options[:fields] || Top4R::Sku.fields)}.merge(options)
    
    response = http_connect {|conn| create_http_get_request(@@ITEM_METHODS[method], params)}
    result = JSON.parse(response.body)[rsp(@@ITEM_METHODS[method])]
    if result.is_a?(Hash) and result['skus']
      items = Top4R::Sku.unmarshal(result["skus"]["sku"])
      items.each {|item| bless_model(item); yield item if block_given?}
    else
      items = []
    end
    items
  end
  
  # 更新库存
  def skus_quantity_update(options = {})
    method = :skus_quantity_update
    response = http_connect {|conn| create_http_get_request(@@ITEM_METHODS[method], options)}
    result = JSON.parse(response.body)[rsp(@@ITEM_METHODS[method])]
    if result.is_a?(Hash) and result['item']
      item = Top4R::Item.unmarshal(result["item"])
    else
      item = nil
    end
    item
  end

  # def http_connect(body=nil, &block)
  #   require_block(block_given?)
  #   connection = create_http_connection
  #   response = nil
  #   connection.start do |connection|
  #     request = yield connection if block_given?
  #     # puts "conn: #{connection.inspect}"
  #     Rails.logger.debug "request============: #{request.inspect}"
  #     timeout(15) do
  #       response = connection.request(request, body)
  #       Rails.logger.debug "response===============: #{response.body}"
  #     end
  #     handle_rest_response(response)
  #     response
  #   end
  # end
  
  @@DELIVERY_METHODS = {
    :send => 'taobao.logistics.offline.send',
    :update_ship_fee => 'taobao.trade.postage.update',
  }
  
  def logistics_offline_send(method = :send, options = {})
    response = http_connect {|conn| create_http_get_request(@@DELIVERY_METHODS[method], options)}
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? json['logistics_offline_send_response']["shipping"]["is_success"] : false
  end
  
  def update_ship_fee(options = {})
    response = http_connect {|conn| create_http_get_request(@@DELIVERY_METHODS[:update_ship_fee], options)}
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? Top4R::Trade.unmarshal(json["trade_postage_update_response"]["trade"]) : json
  end
  
  def item_update_status(method, options = {})
    response = http_connect {|conn| create_http_get_request(@@ITEM_METHODS[method], options)}
    result = JSON.parse(response.body)[rsp(@@ITEM_METHODS[method])]
    result.is_a?(Hash)
  end
  
end

