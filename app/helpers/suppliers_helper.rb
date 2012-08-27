# encoding: utf-8

module SuppliersHelper
  
  def return_suppliers_url
    link_to '返回供应商列表', session[:suppliers_url] || suppliers_path
  end
  
  
end
