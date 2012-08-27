# coding: UTF-8

require 'csv'

class UsersController < ApplicationController

  layout 'no_nav'

  skip_before_filter :require_user, :only => [:login, :check_login, :register, :create]
  skip_before_filter :check_init

  def login
    @user = User.new
  end

  def check_login
    if params[:user].blank? or params[:user][:username].blank? or params[:user][:password].blank?
      flash[:notice] = '用户名和密码不能为空'
      redirect_to :login and return
    end
    
    unless @user = User.valid_by_username_and_password?(params[:user][:username], params[:user][:password])
      flash[:notice] = '用户名或密码错误'
      redirect_to :login and return
    end

    session[:username] = @user.username
    session[:realname] = @user.realname
    session[:user_id] = @user.id
    
    redirect_to :root and return
  end
  
  def logout
    session[:username] = ''
    session[:realname] = ''
    session[:user_id] = ''
    redirect_to :login
  end
  
  def register
    @user = User.new
  end

  def create    
    @user = User.new(params[:user])
   
    # @user.role_id = User::ROLES[:default]
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, :notice => '注册成功，请登录' }
        format.json
      else
        format.html { render :action => "register" }
        format.json
      end
    end
  end

  def init_step_two
    @current_user.setting.update_attribute :status, 'binded'
  end

  def init_sync
    Product.sync(@current_user.id, @current_user.shops.binded)
    Order.sync(@current_user.id, @current_user.shops.binded)
    
    @current_user.setting.update_attribute :status, 'synced'
    
    render :text => 'success'
  end
 
end

