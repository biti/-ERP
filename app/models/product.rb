# -*- encoding : utf-8 -*-

require 'paipai'

class Product < ActiveRecord::Base

  has_one :detail, :class_name => 'ProductDetail', :foreign_key => 'product_id'
  accepts_nested_attributes_for :detail

  has_many :skus
  accepts_nested_attributes_for :skus
  
  belongs_to :user
  
  STATUS = {
    :onsale => {
      :name => '出售中',
      :value => 10,
    },
    :instock => {
      :name => '仓库中',
      :value => 20,
    },
    :sale_on_time => {
      :name => '定时上架',
      :value => 30,
    }
  }
  
  STATUS_MAPPING = {
    :taobao => {
      'onsale' => 10,
      'instock' => 20,
    },
    :paipai => {
      'IS_FOR_SALE' => 10,
      'IS_IN_STORE' => 20,
      'IS_SALE_ON_TIME' => 30,
    },
    :jingdong => {
      
    },
  }
  
  class << self
    
    def shortage
      order("id DESC")
    end
    
    def sync(current_user_id, shops)
      shops.each do |shop|
        platform = PLATFORMS.select{ |k, v| v[:id] == shop.platform_id}.first.first
        __send__("sync_from_#{platform}", current_user_id, shop)
      end
    end

    def sync_from_taobao(current_user_id, shop)
      do_sync_from_taobao(:inventory_list, current_user_id, shop)
      do_sync_from_taobao(:onsale_list, current_user_id, shop)
    end
    
    def do_sync_from_taobao(method, current_user_id, shop)
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )
      
      @top.items_onsale(nil, method)
      total_results = @top.total_results.to_i

      page_size = 2
      page_total = (total_results.to_f/page_size).ceil
      1.upto(page_total) do |i|
        products = []
        logger.debug "i==============%s" % i
        @top.items_onsale(nil, method, {:page_no => i, :page_size => page_size}).each do |item|
          next if item.outer_id.blank?
          next if Product.find_by_outer_custom_id(item.outer_id)

          p = Product.new(
            :user_id => current_user_id,
            :platform_id => PLATFORMS[:taobao][:id],
        	  :name => item.title,
            :outer_id => item.num_iid,
        	  :outer_custom_id => item.outer_id,
            :num => item.num,
          	:detail_url => item.detail_url,
          	:image_url => item.pic_url,
          	:price => item.price,
          	:status => STATUS_MAPPING[:taobao][item.approve_status]
        	)
        	p.save
        	products << p
        	
        end
      
        if products.size > 0
          outer_ids = products.map{|p| p.outer_id}.join(',')
          skus = @top.item_skus_get(outer_ids)
      
          if skus
            skus.each do |sku|
              next if sku.outer_id.blank?

              product_id = products.find{|p| p.outer_id == sku.num_iid}.id
              properties = ''
              sku.properties_name.split(';').each do |s|
                arr = s.split(':')
                properties << "#{arr[2]}:#{arr[3]} "
              end
              
              s = Sku.find_or_initialize_by_outer_custom_id(sku.outer_id)
              s.product_id = product_id,
              s.user_id = current_user_id,
              s.outer_id = sku.sku_id,
              s.outer_custom_id = sku.outer_id,
              s.price = sku.price,
              s.properties = properties,
              s.quantity = sku.quantity
              s.save
              
              stock = Stock.find_or_initialize_by_sku_id_and_platform_id(s.id, shop.platform_id)
              stock.num = s.quantity
              stock.save
              
              pp = products.find{|p| p.outer_id == sku.num_iid}
              pp.update_attribute(:num, pp.num + s.quantity)
            end
          end
        end
      end
    end
    
    def sync_from_paipai(current_user_id, shop, page_index = 1)
      
      url = 'http://api.paipai.com/item/sellerSearchItemList.xhtml'
      options = {    
        'token' => shop.access_token,
        'spid' => shop.spid,
        'skey' => shop.skey,
        
        'cmdid' => 'item.sellerSearchItemList',
        'charset' => 'utf-8',

        'pureData' => 1,
        
        'pageIndex' => page_index,
        'pageSize' => 20,
        
        'uin' => shop.qq,
        'sellerUin' => shop.qq,
      }

      result = Paipai.get(url, options)
      
      logger.info "[paipai sellerSearchItemList results]======%s" % result.inspect
      
      result['itemList'].each do |item|
        next if item['itemLocalCode'].blank?
        next if Product.find_by_outer_custom_id(item['itemLocalCode'])
        
        p = Product.new(
          :user_id => current_user_id,
          :platform_id => PLATFORMS[:paipai][:id],
      	  :name => item['itemName'],
      	  :outer_id => item['itemCode'],
      	  :outer_custom_id => item['itemLocalCode'],
          :num => item['stockCount'].to_i,
        	:detail_url => '',
        	:image_url => item['picLink'],
        	:price => BigDecimal(item['itemPrice']),
        	:status => STATUS_MAPPING[:paipai][item['itemState']]
      	)
      	p.save
      	
      	sku_url = 'http://api.paipai.com/item/getItem.xhtml'
      	
        sku_options = {
          'token' => shop.access_token,
          'spid' => shop.spid,
          'skey' => shop.skey,

          'cmdid' => 'item.getItem',
          'charset' => 'utf-8',

          'pureData' => 1,

          'uin' => shop.qq,
          'sellerUin' => shop.qq,
          
          'itemCode' => item['itemCode'],
        }
        sku_result = Paipai.get(sku_url, sku_options)
        logger.info "[paipai getItem results]======%s" % sku_result.inspect
        
        sku_result['stockList'].each do |sku|
          next if sku['stockLocalCode'].blank?
          s = Sku.find_or_initialize_by_outer_custom_id(sku['stockLocalCode'])
          
          s.product_id = p.id
          s.user_id = current_user_id
          s.outer_id = sku['stockId']
          s.outer_custom_id = sku['stockLocalCode']
          s.price = BigDecimal(sku['stockPrice'])
          s.properties = sku['stockAttr']
          s.quantity = sku['stockCount']
          s.save
          
          stock = Stock.find_or_initialize_by_sku_id_and_platform_id(s.id, shop.platform_id)
          stock.num = s.quantity
          stock.save
          
          p.update_attribute(:num, p.num + s.quantity)
        end
      end
      
      page_total = result['pageTotal'].to_i
      if page_total > page_index
        sync_from_paipai(current_user_id, shop, page_index + 1)
      end
    end
  
    def sync_from_jingdong(current_user_id, shop)
    end
    
    # 调整库存
    def update_inventory(product, params)
      platform = PLATFORMS.select{ |k, v| v[:id] == product.platform_id}.first.first
      __send__("update_#{platform}_inventory", product, params)
    end
    
    def update_taobao_inventory(product, params)
      shop = Shop.where(:platform_id => PLATFORMS[:taobao][:id]).first
      
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )
      
      skuid_quantities = params[:skus_attributes].values.map { |sku| "#{sku[:outer_id]}:#{sku[:quantity]}" }.join(';')
      options = {
        :num_iid => product.outer_id,
        :skuid_quantities => skuid_quantities,
      }

      result = @top.skus_quantity_update(:num_iid => product.outer_id, :skuid_quantities => skuid_quantities)
      logger.info "[taobao update inventory] result========%s" % result.inspect
      
      result ? result.num : nil
    end
    
    def update_paipai_inventory(product, params)
      shop = Shop.where(:platform_id => PLATFORMS[:paipai][:id]).first
      
      url = 'http://api.paipai.com/item/modifyItemStock.xhtml'
      
      params[:skus_attributes].values.each do |sku|
        options = {    
          'token' => shop.access_token,
          'spid' => shop.spid,
          'skey' => shop.skey,
        
          'cmdid' => 'item.modifyItemStock',
          'charset' => 'utf-8',

          'pureData' => 1,
        
          'uin' => shop.qq,
          'sellerUin' => shop.qq,
        
          'itemCode' => product.outer_id,
          'stockId' => sku[:outer_id],
          
          'stockCount' => sku[:quantity],
        }

        result = Paipai.get(url, options)
        logger.info "[paipai sellerSearchItemList results]======%s" % result.inspect        

      end

      return params[:skus_attributes].values.inject(0) { |sum, sku| sum += sku[:quantity].to_i }
    end
    
    def update_jingdong_inventory(product, params)
    end
    
    def do(action, ids)
      hash = Product.where(:id => ids).to_a.group_by { |p| p.platform_id }

      hash.each do |platform_id, products|
        platform = PLATFORMS.select{ |k, v| v[:id] == platform_id}.first.first
        __send__("do_in_#{platform}", action, products)
      end
    end

    def do_in_taobao(action, products)
      shop = Shop.where(:platform_id => PLATFORMS[:taobao][:id]).first
      
      @top = Top4R::Client.new(
        :app_key => Taobao::APP_KEY,
        :app_secret => Taobao::APP_SECRET,
        :parameters => shop.top_parameters,
        :session => shop.top_session
      )

      method = action == :listing ? :item_update_listing : :item_update_delisting
      
      products.each do |product|
        options = {
          :num_iid => product.outer_id,
        }
        options.merge!(:num => product.num) if action == :listing
        
        
        result = @top.item_update_status(method, options)
        logger.info "[taobao do action]==========%s" % result.inspect
        
        if result
          status = action == :listing ? :onsale : :instock
          product.update_attribute :status, STATUS[status][:value]
        end
      end
    end
    
    def do_in_paipai(action, products)
      shop = Shop.where(:platform_id => PLATFORMS[:paipai][:id]).first
      
      url = 'http://api.paipai.com/item/modifyItemState.xhtml'
      item_state = action == 'listing' ? 'IS_FOR_SALE' : 'IS_IN_STORE'
      
      options = {
        'token' => shop.access_token,
        'spid' => shop.spid,
        'skey' => shop.skey,
        
        'cmdid' => 'item.modifyItemState',
        'charset' => 'utf-8',

        'pureData' => 1,
        
        'uin' => shop.qq,
        'sellerUin' => shop.qq,
        
        'itemCode' => products.map{ |p| "itemCode=#{p.outer_id}" }.join('&'),
        'itemState' => item_state,
      }

      result = Paipai.get(url, options)
      logger.info "[paipai do action results]======%s" % result.inspect
      
      if result['errorCode'] == 0
        products.each do |product|
          product.update_attribute :status, STATUS[:instock][:value]
        end
      end
    end
    
    def do_in_jingdong(action, products)
      shop = Shop.where(:platform_id => PLATFORMS[:jingdong][:id]).first
    end
    
  end
  
  
end
