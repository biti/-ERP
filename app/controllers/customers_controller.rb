# coding: UTF-8
class CustomersController < ApplicationController
  
  def index
    @customers = @current_user.customers.order('id DESC').paginate(:page => params[:page], :per_page => 20)

    @taobao_customers = @current_user.customers.count(:conditions => ['platform_id = ?', PLATFORMS[:taobao][:id]])
    @paipai_customers = @current_user.customers.count(:conditions => ['platform_id = ?', PLATFORMS[:paipai][:id]])
    @jingdong_customers = @current_user.customers.count(:conditions => ['platform_id = ?', PLATFORMS[:jingdong][:id]])
    
    @level_nums = {}
    @customer_levels = CustomerLevel.all
    @customer_levels.each do |l|
      @level_nums[l.level] = @current_user.customers.count(:conditions => ['level = ?', l.level])
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end
  
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(customers_path, :notice => 'Customer 创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end
  
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(customers_path, :notice => 'Customer 更新成功。') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end
  
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_path,:notice => "删除成功。") }
      format.json
    end
  end
  
  def level_setting
    @levels = CustomerLevel.order('level').limit(4)
    logger.debug "=====levels=======" % @levels.inspect
  end
    
  def save_level_setting
    logger.debug params[:level].inspect
    params[:level].each do |level_id, level_attributes|
      CustomerLevel.find_by_id(level_id).update_attributes(level_attributes)
    end
    
    redirect_to level_setting_customers_path, :notice => '保存成功'
  end
end