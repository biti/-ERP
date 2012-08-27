# coding: UTF-8

class OrdersController < ApplicationController
  
  before_filter :filter_orders, :only => [:index, :waiting_pay, :waiting_delivery, :delivery, 
    :refunding, :successed, :need_comment, :closed, :three_months_ago]
  
  def filter_orders
    @orders = @current_user.orders.includes(:items)
    
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
    
    @orders = @orders.order('id DESC').paginate(:page => params[:page], :per_page => 20)
  end
  
  def index
  end
  
  def waiting_pay
    @orders = @orders.where("status = ?", 'wait_buyer_pay')
    render :index    
  end

  def waiting_delivery
    @orders = @orders.where("status = ?", 'wait_seller_delivery')
    render :index
  end

  def delivery
    @orders = @orders.where("status = ?", 'seller_delivery')
    render :index
  end

  def refunding
    @orders = @orders.where("status = ?", 'refunding')
    render :index
  end
  
  def successed
    @orders = @orders.where("status = ?", 'success')
    render :index
  end
  
  def need_comment
    @orders = @orders.where("status = ?", 'need_comment')
    render :index
  end
  
  def closed
    @orders = @orders.where("status = ?", 'closed')
    render :index
  end
  
  def three_months_ago
    @orders = @orders.where("order_time <= ?", 3.months.ago)
    render :index
  end
  
  def show
    @dan = Dan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end
  
  def new
    @order = Order.new
  end
  
  def edit
    @dan = Dan.find(params[:id])
    @users = User.all
  end
  
  def create
    @order = Order.new
    file = params[:order][:file]

    if Order.import(file)
      render :action => 'new', :notice => '保存成功。'
    else
      render :action => "new"
    end
  end
  
  def update
    @dan = Dan.find(params[:id])

    respond_to do |format|
      if @dan.update_attributes(params[:dan])
        format.html { redirect_to( dan_path(@dan), :notice => '保存成功。') }
        format.json
      else
        @users = User.all
        format.html { render :action => "edit" }
        format.json
      end
    end
  end
  
  def destroy
    @dan = Dan.find(params[:id])
    @dan.destroy

    respond_to do |format|
      format.html { redirect_to( (session[:dans_url] || dans_url), :notice => '删除成功。') }
      format.json
    end
  end

  def check
    @dan = Dan.find(params[:id])
  end

  def save_check
    @dan = Dan.find(params[:id])

    respond_to do |format|
      if @dan.update_attributes(params[:dan])
        format.html { redirect_to( dan_path(@dan), :notice => '保存成功。') }
        format.json
      else
        format.html { render :action => "check" }
        format.json
      end
    end
  end

  def page
    @dan = Dan.find(params[:id])
  end

  def save_page
    @dan = Dan.find(params[:id])

    respond_to do |format|
      if @dan.update_attributes(params[:dan])
        format.html { redirect_to( dan_path(@dan), :notice => '保存成功。') }
        format.json
      else
        format.html { render :action => "page" }
        format.json
      end
    end
  end

  def toggle_pass
    @dan = Dan.find(params[:id])

    if @dan.update_attribute(params[:dan].keys.first, params[:dan].values.first)
      render :text => 'ok'
    else
      render :text => 'error'
    end
  end

  def csv(dans)
    #@dans = Dan.where("online_time = ?", params[:date])

    tmp_array = []
    tmp_array << ['品名', '责任人', '排期', '原价', '底价', '上线价', '商家名称', '商家电话', '商家qq',
      'OA id','合同id', '页面提交id', '链接']

    dans.each do |d|
      tmp_array << [d.name, d.user.realname, d.online_time, d.price, d.base_price, d.online_price,
         d.partner_name, d.partner_service_tel, d.partner_qq, 
        d.oa_id, d.contract_id, d.page_id, d.link]
    end

    send_data(array_to_csv(tmp_array), :filename => "paidan.csv")
  end

  # 把二维数据转换为csv格式
  def array_to_csv(arr)
    csv_string = ''
  
    #utf-8 bom, 用于windows识别utf-8编码
    #bom_head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
    #csv_string << bom_head
  
    csv_string << CSV.generate do |csv|
      arr.each do |row|
        csv << row
      end
    end

    csv_string
  end
  
  # 同步运程订单
  def sync
    cookies[:last_sync_time] = Time.now.to_i
    
    Order.sync(@current_user.id, @current_user.shops.binded)
    redirect_to orders_path, :notice => "订单同步成功."
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
