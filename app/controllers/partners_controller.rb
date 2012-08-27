# coding: UTF-8

require 'csv'

class PartnersController < ApplicationController

  layout 'no_nav'

  skip_before_filter :require_partner, :only => [:login, :check_login, :register, :create]
  skip_before_filter :check_init

  def login
    @partner = Partner.new
  end

  def check_login
    if params[:partner].blank? or params[:partner][:login].blank? or params[:partner][:password].blank?
      flash[:notice] = '用户名和密码不能为空'
      redirect_to :login and return
    end
    
    unless @partner = Partner.valid_by_login_and_password?(params[:partner][:login], params[:partner][:password])
      flash[:notice] = '用户名或密码错误'
      redirect_to :login and return
    end

    session[:login] = @partner.login
    session[:name] = @partner.name
    session[:partner_id] = @partner.id
    
    redirect_to :root and return
  end
  
  def logout
    session[:login] = ''
    session[:name] = ''
    session[:partner_id] = ''
    redirect_to :login
  end
  
  def register
    @partner = Partner.new
  end

  def create    
    @partner = Partner.new(params[:partner])
    
    respond_to do |format|
      if @partner.save
        format.html { redirect_to login_url, :notice => '注册成功，请登录' }
        format.json
      else
        format.html { render :action => "register" }
        format.json
      end
    end
  end
 
end

