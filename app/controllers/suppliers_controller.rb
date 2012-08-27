# coding: UTF-8
class SuppliersController < ApplicationController
  
  def index
    session[:suppliers_url] = request.fullpath

    @suppliers = Supplier.where('1 = 1')

    unless params[:filters].try(:[], :brand).blank?
      @suppliers = @suppliers.where("brand like '%#{params[:filters][:brand].strip}%'")
    end
    unless params[:filters].try(:[], :buyer_id).blank?
      @suppliers = @suppliers.where("buyer_id = ?", params[:filters][:buyer_id])
    end
    unless params[:filters].try(:[], :status).blank?
      @suppliers = @suppliers.where("status = ?", params[:filters][:status])
    end
    
    if @current_user.role_id.to_i != User::ROLES[:admin]
      @suppliers = @suppliers.where("buyer_id = ?", @current_user.id)
    end
    
    @suppliers = @suppliers.order('id DESC').paginate(:page => params[:page], :per_page => 20)
          
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json
    end
  end
  
  def new
    @supplier = Supplier.new
    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.json
    end
  end
  
  def edit
    @supplier = Supplier.find(params[:id])
    @users = User.all
  end
  
  def create
    @supplier = Supplier.new(params[:supplier]) do |s|
      s.status = :weilianxi.to_s
    end

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to(suppliers_path, :notice => 'Supplier 创建成功。') }
        format.json
      else
        @users = User.all
        format.html { render :action => "new" }
        format.json
      end
    end
  end
  
  def update
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @supplier.update_attributes(params[:supplier])
        format.html { redirect_to(supplier_path(@supplier), :notice => '保存成功。') }
        format.json
      else
        @users = User.all
        format.html { render :action => "edit" }
        format.json
      end
    end
  end
  
  def follow
    @supplier = Supplier.find(params[:id])
  end
  
  def save_follow
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @supplier.update_attributes(params[:supplier])
        format.html { redirect_to(supplier_path(@supplier), :notice => '保存成功。') }
        format.json
      else
        @users = User.all
        format.html { render :action => "edit" }
        format.json
      end
    end
  end

  
  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to( (session[:suppliers_url] || suppliers_url), :notice => '删除成功。') }
      format.json
    end
  end
end