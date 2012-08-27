# encoding: utf-8

module ApplicationHelper
  
  #　根据账号判断绑定链接
  def bind_link(shop, source_url)
    platform = PLATFORMS.select{ |k, v| v[:id] == shop.platform_id}.first.first
    
    case platform
    when :paipai
      link_to '绑定', '#bind-paipai', 'data-toggle' => 'modal'
    else
      link_to '绑定', __send__("bind_#{platform}_auth_index_path") + '?source_url=' + source_url + '&height=550&TB_iframe=true',
       :id => 'bind-thickbox', :class => 'thickbox'
    end
  end
  
  def human_platform(platform_id)
    """
    <span class='label' style='background-color:#{PLATFORMS.find{|k, v| v[:id] == platform_id}.try(:last).try(:[], :color) }'>
      #{PLATFORMS.find{|k, v| v[:id] == platform_id}.try(:last).try(:[], :name) }
    </span>
    """
  end
  
  def sku_tag(sku, shortage_skus)
    quantity_style = ''
    shortage_skus.each do |s|
      quantity_style = 'color:red;' if s.id == sku.id
    end
    
    """
      <span style='background: none repeat scroll 0 0 #F8EAF4;border: 1px solid #CCC;float: left;margin: 2px 5px;padding: 0 5px;width:px;'>
        #{ sku.properties }
        <strong style='#{quantity_style}'>#{sku.quantity}</strong>
      </span>            
    """
  end
  
end
