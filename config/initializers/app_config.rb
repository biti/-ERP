# encoding: utf-8

TEMPLATE_OPTIONS = {
  :order_no => '订单号',
  :sender_name => '发件人姓名',
  :sender_phone => '发件人电话',
  :sender_company => '发件人公司',
  :sender_address => '发件人地址',
  :sender_zip => '发件人邮编',
  
  :receiver_name => '收件人姓名',
  :receiver_phone => '收件人电话',
  :receiver_address => '收件人地址',
  :receiver_zip => '收件人邮编',
  
  :collect_money => '货到付款代收金额',
  :order_code => '货到付款物流编号',
  
  :remark => '备注',
  
  :product_info => "货物信息（名称，颜色，尺码等）",
}

LOGISTICS_COMPANIES = {
  :yuantong => {
    :name => '圆通',
    :no_format => '^[0-9]{10}$',
    :taobao_code => 'YTO',
  },
  
  :zhongtong => {
    :name => '中通',
    :no_format => '^[0-9]{12}$',
    :taobao_code => 'ZTO',
  }, 
  :shentong => {
    :name => '申通',
    :no_format => '12 nums',
    :taobao_code => 'STO',
  },
  :shunfeng => {
     :name => '顺丰',
     :no_format => '12 nums',
     :taobao_code => 'SF',
   }, 
  :ems => {
    :name => '邮政EMS',
    :no_format => 'EH + 9nums + CS',
    :taobao_code => 'EMS',
  },
  :huitong => {
    :name => '汇通',
    :no_format => '13 nums',
    :taobao_code => 'HTKY',
  },
  :yunda => {
    :name => '韵达',
    :no_format => '13 nums',
    :taobao_code => 'YUNDA',
  },
  
  :zhaijisong => {
    :name => '宅急送',
    :no_format => '10nums',
    :taobao_code => 'ZJS',
  },
}

PLATFORMS = {
  :taobao => {
    :name => '淘宝',
    :id => 10,
    :color => '#F50',
    :status_mapping => {
      'TRADE_NO_CREATE_PAY' => :wait_buyer_pay,
      'WAIT_BUYER_PAY' => :wait_buyer_pay,
      'WAIT_SELLER_SEND_GOODS' => :wait_seller_delivery,
      'WAIT_BUYER_CONFIRM_GOODS' => :seller_delivery,
      'TRADE_BUYER_SIGNED' => :signed,
      'TRADE_FINISHED' => :successed,
      'TRADE_CLOSED' => :closed,
      'TRADE_CLOSED_BY_TAOBAO' => :closed,
    }
  },
  
  :paipai => {
    :name => '拍拍',
    :id => 20,
    :color => '#C3A4DD',
    :status_mapping => {
      'DS_UNKNOWN' => :unknown,
      'DS_WAIT_BUYER_PAY' => :wait_buyer_pay,
      'DS_WAIT_SELLER_DELIVERY' => :wait_seller_delivery,
      'DS_WAIT_BUYER_RECEIVE' => :seller_delivery,
      'DS_DEAL_END_NORMAL' => :successed,
      'DS_DEAL_CANCELLED' => :canceled,
      'DS_SYSTEM_HALT' => :system_halt,
      'DS_SYSTEM_PAYING' => :system_paying,
      'DS_DEAL_REFUNDING' => :refunding,
    }
  },
  
  :jingdong => {
    :name => '京东',
    :id => 30,
    :color => '#2E82D0',
    :status_mapping => {
      'WAIT_SELLER_STOCK_OUT' => :wait_stock_out,
      'WAIT_SELLER_DELIVERY ' => :wait_seller_delivery,
      'TRADE_CANCELED'        => :canceled,
    }
  },
  
  :yihaodian => {
    :name => '一号店',
    :id => 40,
    :color => 'black',
    :status_mapping => {
    }
  },
  
  :vjia => {
    :name => 'V+',
    :id => 50,
    :color => '#DC0050',
    :status_mapping => {
    }
  },
  
}

module Taobao
  APP_KEY = '12539943'
  BIND_URL = "http://container.api.taobao.com/container?appkey=#{APP_KEY}&encode=utf-8"
  
  APP_SECRET = 'a7cb4de1bd060f6b7e5dc4b02bd4f0f5'
end

Top4R::Client.configure do |conf|
  conf.application_name = '简智进销存'
  conf.application_version = "0.1.0"
  conf.application_url = 'http://erp.sim-ulti.com:3000/taobao_callback'
  conf.env = :production
  conf.trace = true
  conf.logger = Rails.logger
end

module Paipai
end

module Jingdong
  APP_KEY = 'A6E84CA98F320E4B391985FACA10CB28'
  APP_SECRET = '41be4c22cd25488cb2f7d3588acc3d1e'
end

module Yihaodian
  
end

module Vjia
end


