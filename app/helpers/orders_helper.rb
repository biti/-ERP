# encoding: utf-8

module OrdersHelper
  
  def return_url
    link_to '返回订单列表', session[:orders_url] || orders_path
  end
  
end
