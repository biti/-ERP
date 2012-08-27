# encoding: utf-8

class Contact < ActiveRecord::Base  
  
  def human_address
    """
    收件人：#{name} 
    电话：#{mobile}, #{phone} 
    邮编：#{zip} 
    地址：#{state} #{city} #{district} #{address}
    """
  end
  
end
