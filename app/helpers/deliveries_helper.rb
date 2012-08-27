# encoding: utf-8

module DeliveriesHelper

  def template_select
    options = []
    h = {:prompt => ' 请选择　'}
    unless @templates.blank?
      options = @templates.map{|item| [item.name,item.id]}
      h = {}
    end
    
    select :delivery, :template_id, options, h, :class => 'span2 '
    
  end
  
  # 根据模板配置生成打印项的css（用于打印）
  def print_fields_css(options_json)    
    options = JSON.parse options_json
    logger.debug "optoins======%s" % options.inspect
    css_string = ''
    
    options.each do |option|
      option = class_eval(option)
      
      name = option.delete(:name)
      s = option.map { |k, v| "#{k}: #{ v.gsub('px', '').to_i/3 }mm"}.join(';')
      css_string << ".#{name}{#{s}}\n"
    end
    
    css_string
  end
  
  # 根据模板配置生成打印项的css
  def fields_css(options_json)
    options = JSON.parse options_json
    logger.debug "optoins======%s" % options.inspect
    css_string = ''
    
    options.each do |option|
      option = class_eval(option)
      
      name = option.delete(:name)
      s = option.map { |k, v| "#{k}:#{v}"}.join(';')
      css_string << ".#{name}{#{s}}\n"
    end
    
    css_string
  end

  def show_field(order, field_name)
    case field_name
    when 'sender_name'
      @address.name
    when 'sender_phone'
      @address.human_tel
    when 'sender_company'
      @address.company
    when 'sender_address'
      @address.human_address
    when 'sender_zip'
      @address.zip
    when 'receiver_name'
      order.name
    when 'receiver_phone'
      order.human_tel
    when 'receiver_address'
      order.zip
    when 'receiver_zip'
      order.zip
    when 'order_no'
      order.outer_id
    when 'buyer_message'
      order.remark
    when 'product_info'
      order.human_products_info
    when 'collect_money'
      '货到付款金额'
    when 'order_code'
      '货到付款单号'
    end
  end
end
