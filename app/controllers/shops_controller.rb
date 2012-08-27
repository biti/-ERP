# encoding: utf-8
require 'paipai'

class ShopsController < ApplicationController
  skip_before_filter :check_init, :only => [:index, :update]
  
  def index
    @shops = @current_user.shops
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shops }
    end
  end
  
  def new
    @shop = Shop.new
  end
  
  def create
    @shop = Shop.new params[:shop]
    @shop.user_id = @current_user.id
    
    if @shop.save
      redirect_to shops_path
    else
      render new_shop_path
    end
  end
    
  def update
    unless valid_params?
        render :status => 200, :text => '账号信息有误' and return
    end
    
    @shop = @current_user.shops.find(params[:id])
    @shop.binded = true
    if @shop.update_attributes params[:shop]
      render :status => 200, :text => 'success'
    else
      render :status => 200, :text => '保存失败'
    end
  end
  
  private 
  def valid_params?
    url = 'http://api.paipai.com/item/sellerSearchItemList.xhtml'
    options = {    
      'token' => params[:shop][:access_token],
      'spid' => params[:shop][:spid],
      'skey' => params[:shop][:skey],
      
      'cmdid' => 'item.sellerSearchItemList',
      'charset' => 'utf-8',

      'pureData' => 1,
      'pageSize' => 1,
            
      'uin' => params[:shop][:qq],
      'sellerUin' => params[:shop][:qq],
    }

    result = Paipai.get(url, options)
    
    logger.info "[paipai sellerSearchItemList results]======%s" % result.inspect
    
    result['errorCode'] == 0
  end
  
end
