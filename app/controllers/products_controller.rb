# encoding: UTF-8
class ProductsController < ApplicationController

  before_filter :filter_products, :only => [:index, :instock, :smart_sale]
  
  def filter_products
    @products = @current_user.products.includes(:skus).order('id DESC').paginate(:page => params[:page], :per_page => 20)

    unless params[:q].blank?
      @products = @products.where("outer_id = '#{params[:q].strip}' or name like '%#{params[:q].strip}%'")
    end
    
    unless params[:min].blank?
      @shortage_skus = Sku.where("quantity < ?", params[:min].to_i)
      @products = @products.where(:id => @shortage_skus.map{ |sku| sku.product_id } )
    else
      @shortage_skus = []
    end
  end
  
  def index  
    @products = @products.where(:status => Product::STATUS[:onsale][:value])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end
  
  def instock
    @products = @products.where(:status => Product::STATUS[:instock][:value])
    respond_to do |format|
      format.html { render :index }
      format.json
    end
  end
  
  # 智能上下架
  def smart_sale
    respond_to do |format|
      format.html 
      format.json
    end
  end
  
  def edit_sale
    
  end

  def inventory
    @products = Product.order('id DESC').paginate(:page => params[:page], :per_page => 20)

    unless params[:q].blank?
      @products = @products.where("outer_id = '#{params[:q].strip}' or name like '%#{params[:q].strip}%'")
    end

    unless params[:min].blank?
      @products = @products.where("total < ?", params[:min].to_i)
    end
    
  end
  
  def edit_inventory
    @product = Product.find(params[:id])
  end

  def shortage
    @products = Product.shortage.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end
  
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end
  
  def new
    @product = Product.new
    @product.build_detail

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def create
    @product = Product.new(params[:product])
    @product.user_id = @current_user.id

    respond_to do |format|
      if @product.save
        format.html { redirect_to(products_path, :notice => '创建成功。') }
        format.json
      else
        format.html { render :action => "new" }
        format.json
      end
    end
  end
  
  # 更新商品
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(edit_product_path(@product), :notice => '更新成功') }
        format.json
      else
        format.html { render :action => "edit" }
        format.json
      end
    end
  end
  
  # 更新库存
  def update_inventory
    @product = Product.find(params[:id])

    respond_to do |format|
      num = Product.update_inventory(@product, params[:product])
      if num
        @product.update_attributes params[:product].merge(:num => num)
        
        format.html { redirect_to(edit_inventory_product_path(@product), :notice => '修改成功') }
        format.json
      else
        format.html { redirect_to(edit_inventory_product_path(@product), :notice => '') }
        format.json
      end
    end
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_path,:notice => "删除成功。") }
      format.json
    end
  end
  
  def stocks
    @products = Product.order('id DESC').paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end
  
  def sync
    # if cookies[:last_sync_time] and Time.at(cookies[:last_sync_time].to_i)  > 5.minutes.ago
    #   redirect_to products_path, :notice => '两次同步时间间隔不能小于5分钟！' and return
    # end

    cookies[:last_sync_time] = Time.now.to_i
        
    Product.sync(@current_user.id, @current_user.shops.binded)
    redirect_to :action => :index
  end
  
  def listing
    Product.do(:listing, params[:ids].split(','))
    redirect_to instock_products_path
  end
  
  def delisting
    Product.do(:delisting, params[:ids].split(','))
    redirect_to products_path
  end
end


