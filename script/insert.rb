

1.upto(1000) do |i|
  puts i
  1.upto(30) do |day|
    Dan.create(:name => '测试一单', :remark => '测试请您在购买时仔细填好您的详细收货地址、姓名和电话，我们会在团购结束后7个工作日内按照购买顺序进行配送，请您耐心等待，有关于产品咨询和发货的问题请拨打客服电话：4000-517-717进行咨询', 
    :online_time => "2012-6-#{day}", :user_id => 4, :price => 1.0, :base_price => 1.0, :online_price => 1.0, :partner_name => '测试商家', :partner_tel => '111111')
  end
end