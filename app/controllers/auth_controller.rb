class AuthController < ApplicationController
  
  skip_before_filter :check_init
  
  def bind_taobao
    redirect_to "#{Taobao::BIND_URL}&state=#{params[:source_url]}"
  end
  
  def taobao_callback
    @shop = @current_user.shops.where(:platform_id => PLATFORMS[:taobao][:id]).first
    logger.debug "@shop====%s" % @shop.inspect
    
    @shop.top_session = params[:top_session]
    @shop.top_parameters = params[:top_parameters]
    @shop.binded = true
    @shop.save

    # if @current_user.setting.status == 'new_user'
    #   render :template => 'auth/callback'
    # else
    logger.debug "state================%s" % params[:state]
      redirect_to __send__(params[:state])
    # end
  end
  
  def bind_jingdong
    redirect_to 'http://auth.360buy.com/oauth/authorize?response_type=code&client_id=A6E84CA98F320E4B391985FACA10CB28&redirect_uri=http://127.0.0.1:9393/auth&state=mystate&scope=read'
  end
  
  def jingdong_callback

    url = "http://auth.sandbox.360buy.com/oauth/token"

    options = {
      grant_type: 'authorization_code',
      client_id: Jingdong::APP_KEY,
      redirect_uri: 'http://127.0.0.1:9393/auth',
      code: params['code'],
      state: 'mystate', 
      client_secret: Jingdong::APP_SECRET,
    }

    # 获取access_token
    unless session[:jingdong_access_token]
      response = RestClient.post url, options
      
      access_token = JSON.parse(response.body)['access_token']
      session[:jingdong_access_token] = access_token
    end
    
    if @current_user.setting.status == 'new_user'
      render :template => 'auth/callback'
    else
      redirect_to shops_url
    end
  end
  
  def bind_vplus
    
  end
  
end
