# encoding: utf-8

class Supplier < ActiveRecord::Base
  
  validates_presence_of :brand, :company, :status, :eshop, :buyer_id
  
  belongs_to :buyer, :class_name => 'User', :foreign_key => :buyer_id
  
  STATUS = {
    :weilianxi => '未联系',
    :yilianxi => '已联系，正在跟进',
    :yuanyihezuo => '愿意合作',
    :buyuanhezuo => '不愿合作',
    :yijinghezuo => '已经合作',
  }
  
  STATUS_COLORS = {
    :weilianxi => 'black',
    :yilianxi  => 'blue',
    :yuanyihezuo => 'orange',
    :buyuanhezuo => 'red',
    :yijinghezuo => 'green',
  }
  
  def human_status
    "<span style='color:#{STATUS_COLORS[status.to_sym]}'>#{STATUS[status.to_sym]}</span>"
  end
  
  
end
