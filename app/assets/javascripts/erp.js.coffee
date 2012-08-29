window.App =
  Models: {}
  Views:
    Dashboard:
      Index: {}
    Orders:
      Index: {}
    Deliveries:
      Index: {}
    Products:
      Index: {}
      SelectCategory: {}
    Charts:
      Index: {}
          
  Constants:
    TEMPLATE_FIELDS:
      order_no: "订单号"
      sender_name: "发货人"
      sender_phone: "发货人电话"
      sender_company: "发货人公司"
      sender_address: "发货人地址"
      sender_zip: "发货人邮编"
      receiver_name: "收件人"
      receiver_phone: "收件人电话"
      receiver_address: "收件人地址"
      receiver_zip: "收件人邮编"
      collect_money: "货到付款金额"
      order_code: "货到付款单号"
      remark: "备注"
      product_info: "货物信息（名称，颜色，尺码等）"

    TEMPLATES: [
      ename: "yuantong"
      name: "圆通"
      image_url: "/images/templates/yuantong.jpg"
      width: 217
      height: 126
      fields: ["order_no", "sender_name", "sender_phone", "sender_company", "sender_address", "sender_zip", "receiver_name", "receiver_phone", "receiver_address", "receiver_zip", "remark", "product_info"]
      options: [
        name: "sender_name"
        width: 100
        height: 14
        left: 100
        top: 76
      ,
        name: "sender_phone"
        width: 100
        height: 14
        left: 70
        top: 190
      ,
        name: "sender_company"
        width: 100
        height: 14
        left: 70
        top: 100
      ,
        name: "sender_address"
        width: 200
        height: 30
        left: 60
        top: 130
      ,
        name: "sender_zip"
        width: 100
        height: 14
        left: 200
        top: 190
      ,
        name: "receiver_name"
        width: 100
        height: 14
        left: 360
        top: 80
      ,
        name: "receiver_phone"
        width: 100
        height: 14
        left: 350
        top: 190
      ,
        name: "receiver_address"
        width: 200
        height: 30
        left: 370
        top: 140
      ,
        name: "receiver_zip"
        width: 100
        height: 14
        left: 470
        top: 190
      ,
        name: "remark"
        width: 200
        height: 30
        left: 350
        top: 230
      ,
        name: "product_info"
        width: 200
        height: 30
        left: 70
        top: 230
      ]
    ,
      ename: "zhongtong"
      name: "中通"
      image_url: "/images/templates/zhongtong.jpg"
      width: 217
      height: 126
      fields: ["order_no", "sender_name", "sender_phone", "sender_company", "sender_address", "sender_zip", "receiver_name", "receiver_phone", "receiver_address", "receiver_zip", "remark"]
      options: [
        name: "sender_name"
        width: 100
        height: 14
        left: 100
        top: 76
      ,
        name: "sender_phone"
        width: 100
        height: 14
        left: 70
        top: 190
      ,
        name: "sender_company"
        width: 100
        height: 14
        left: 70
        top: 100
      ,
        name: "sender_address"
        width: 200
        height: 30
        left: 60
        top: 130
      ,
        name: "sender_zip"
        width: 100
        height: 14
        left: 200
        top: 190
      ,
        name: "receiver_name"
        width: 100
        height: 14
        left: 360
        top: 80
      ,
        name: "receiver_phone"
        width: 100
        height: 14
        left: 350
        top: 190
      ,
        name: "receiver_address"
        width: 200
        height: 30
        left: 370
        top: 140
      ,
        name: "receiver_zip"
        width: 100
        height: 14
        left: 470
        top: 190
      ,
        name: "remark"
        width: 200
        height: 30
        left: 350
        top: 230
      ]
    ,
      ename: "shentong"
      name: "申通"
      image_url: "/images/templates/shentong.jpg"
      width: 217
      height: 126
      fields: ["order_no", "sender_name", "sender_phone", "sender_company", "sender_address", "sender_zip", "receiver_name", "receiver_phone", "receiver_address", "receiver_zip", "remark"]
      options: [
        name: "sender_name"
        width: 100
        height: 14
        left: 100
        top: 76
      ,
        name: "sender_phone"
        width: 100
        height: 14
        left: 70
        top: 190
      ,
        name: "sender_company"
        width: 100
        height: 14
        left: 70
        top: 100
      ,
        name: "sender_address"
        width: 200
        height: 30
        left: 60
        top: 130
      ,
        name: "sender_zip"
        width: 100
        height: 14
        left: 200
        top: 190
      ,
        name: "receiver_name"
        width: 100
        height: 14
        left: 360
        top: 80
      ,
        name: "receiver_phone"
        width: 100
        height: 14
        left: 350
        top: 190
      ,
        name: "receiver_address"
        width: 200
        height: 30
        left: 370
        top: 140
      ,
        name: "receiver_zip"
        width: 100
        height: 14
        left: 470
        top: 190
      ,
        name: "remark"
        width: 200
        height: 30
        left: 350
        top: 230
      ]
    ,
      ename: "ems"
      name: "邮政EMS"
      image_url: "/images/templates/ems.jpg"
      width: 217
      height: 126
      fields: ["order_no", "sender_name", "sender_phone", "sender_company", "sender_address", "sender_zip", "receiver_name", "receiver_phone", "receiver_address", "receiver_zip", "remark"]
      options: [
        name: "sender_name"
        width: 100
        height: 14
        left: 100
        top: 76
      ,
        name: "sender_phone"
        width: 100
        height: 14
        left: 70
        top: 190
      ,
        name: "sender_company"
        width: 100
        height: 14
        left: 70
        top: 100
      ,
        name: "sender_address"
        width: 200
        height: 30
        left: 60
        top: 130
      ,
        name: "sender_zip"
        width: 100
        height: 14
        left: 200
        top: 190
      ,
        name: "receiver_name"
        width: 100
        height: 14
        left: 360
        top: 80
      ,
        name: "receiver_phone"
        width: 100
        height: 14
        left: 350
        top: 190
      ,
        name: "receiver_address"
        width: 200
        height: 30
        left: 370
        top: 140
      ,
        name: "receiver_zip"
        width: 100
        height: 14
        left: 470
        top: 190
      ,
        name: "remark"
        width: 200
        height: 30
        left: 350
        top: 230
      ]
    ]

    LOGISTICS_COMPANIES: [
      ename: "yuantong"
      name: "圆通"
      no_format: "^[0-9]{10}$"
      taobao_code: "YTO"
    ,
      ename: "zhongtong"
      name: "中通"
      no_format: "^[0-9]{12}$"
      taobao_code: "ZTO"
    ,
      ename: "shentong"
      name: "申通"
      no_format: "^[0-9]{12}$"
      taobao_code: "STO"
    ,
      ename: "shunfeng"
      name: "顺丰"
      no_format: "^[0-9]{12}$"
      taobao_code: "SF"
    ,
      ename: "ems"
      name: "邮政EMS"
      no_format: "^[A-Z]{2}[0-9]{9}[A-Z]{2}$"
      taobao_code: "EMS"
    ,
      ename: "huitong"
      name: "汇通"
      no_format: "^[0-9]{13}$"
      taobao_code: "HTKY"
    ,
      ename: "yunda"
      name: "韵达"
      no_format: "^[0-9]{13}$"
      taobao_code: "YUNDA"
    ,
      ename: "zhaijisong"
      name: "宅急送"
      no_format: "^[0-9]{10}$"
      taobao_code: "ZJS"
    ]
  