class DeliveriesController < ApplicationController
  before_filter :filter_orders, :only => [:index, :waiting_delivery, :deliverying, :delivered]
  
  def filter_orders
    @orders = @current_user.orders
    
    unless params[:filters].try(:[], :name).blank?
      @orders = @orders.where("name = ?", params[:filters][:name].strip)
    end

    unless params[:filters].try(:[], :outer_id).blank?
      @orders = @orders.where("outer_id = ?", params[:filters][:outer_id].strip)
    end

    unless params[:filters].try(:[], :status).blank?
      @orders = @orders.where("status = ?", params[:filters][:status].strip)
    end

    unless params[:filters].try(:[], :order_time_start).blank?
      @orders = @orders.where("order_time >= ?", params[:filters][:order_time_start])
    end

    unless params[:filters].try(:[], :order_time_end).blank?
      @orders = @orders.where("order_time <= ?", params[:filters][:order_time_end])
    end
    
    @orders = @orders.order('id DESC').paginate(:page => params[:page], :per_page => 50)
  end
  
  def index
    @orders = @orders.where("status = ?", 'wait_seller_delivery')
    @templates = @current_user.delivery_templates
    logger.debug "========%s" % @templates.inspect
    render :index    
  end
  
  def deliverying
    @orders = @orders.where("status = ?", 'seller_delivery')
    render :index
  end
  
  def delivered
    @orders = @orders.where("status = ?", 'signed')
    render :index
  end
  
  def edit_delivery
    @orders = Order.where(:id => params[:ids].split(','))
    @address = Address.first
    
    @address_groups = @orders.group_by(&:human_address)
    logger.debug "address_goups=====%s" % @address_groups.inspect
  end

  def save_address
    @address = Address.first
    if @address
      @address.update_attributes params[:address]
    else
      @address = Address.create params[:address]
    end
    render :json => {:result => 'success', :address => @address.human_address}
  end
  
  def shipping_in_volume
    Order.shipping(params)
    
    render :json => {:result => 'success'}
  end
  
  def print_expresses
    @template = @current_user.delivery_templates.find(params[:delivery][:template_id])
    
    @template_fields = JSON.parse(@template.fields)
    
    @orders = Order.where(:id => params[:ids].split(','))
    logger.debug "========%s" % @orders.inspect
    
    @address = Address.first

    render :layout => false
  end

  def print_goods
    @orders = Order.where(:id => params[:ids].split(','))
    logger.debug "========%s" % @orders.inspect
    
    @items = @orders.inject([]) { |arr, o| arr += o.items }
    logger.debug "items======%s" % @items.inspect
    
    @total_amount = @items.inject(0) { |sum, i| sum += BigDecimal(i.price) * i.quantity.to_i }
    logger.debug "total_amount======%s" % @total_amount
    
    hash = @items.group_by { |item| item.product_outer_id }
    @goods = []
      
    hash.each do |product_outer_id, items|
      num = items.inject(0) { |sum, item| sum += item.quantity.to_i }
      price = BigDecimal(items.first.price)
      amount = price * num
      
      @goods << {
        :product_outer_id => items.first.product_outer_id,
        :product_name => items.first.product_name,
        :sku_info => items.first.sku_properties_name,
        :position => '',
        :price => price,
        :num => num,
        :amount => amount,
      }
    end
    
    logger.debug "goods======%s" % @goods.inspect
    
    render :layout => false
  end
  
end
