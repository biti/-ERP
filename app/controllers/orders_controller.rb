# coding: UTF-8

class OrdersController < ApplicationController
  
  before_filter :filter_orders, :only => [:index, :waiting_pay, :waiting_delivery, :delivery, 
    :refunding, :successed, :need_comment, :closed, :three_months_ago]
  
  def filter_orders
    @orders = @current_partner.orders.includes(:items)
    
    unless params[:filters].try(:[], :name).blank?
      @orders = @orders.where("name = ?", params[:filters][:name].strip)
    end

    unless params[:filters].try(:[], :id).blank?
      @orders = @orders.where("id = ?", params[:filters][:id].strip)
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
    
    @orders = @orders.order('id DESC').paginate(:page => params[:page], :per_page => 20)
  end
  
  def index
  end
  
  def waiting_pay
    @orders = @orders.where("status = ?", Order::STATUS[:waiting_pay][:value])
    render :index    
  end

  def waiting_delivery
    @orders = @orders.where("status = ?", Order::STATUS[:paid][:value])
    render :index
  end

  def delivery
    @orders = @orders.where("status = ?", Order::STATUS[:shipped][:value])
    render :index
  end

  def refunding
    @orders = @orders.where("status = ?", 'refunding')
    render :index
  end
  
  def successed
    @orders = @orders.where("status = ?", Order::STATUS[:completed][:value])
    render :index
  end
  
  def three_months_ago
    @orders = @orders.where("order_time <= ?", 3.months.ago)
    render :index
  end
  
  def show
  end
  
  # 批量修改运费
  def update_ship_fee
    result = Order.update_ship_fee(params)
    render :json => result.to_json
  rescue Top4R::RESTError => e
    render :json => e.to_json
  end
  
  # 批量备注
  def remark
    
  end
  
end
