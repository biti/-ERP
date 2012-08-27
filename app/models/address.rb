# encoding: utf-8

class Address < ActiveRecord::Base
  
  def human_tel
    "#{mobile} #{phone}"
  end
  
  def human_address
    "#{state}#{city}#{district}，#{zip}，#{name}，#{mobile} #{phone}"
  end
  
end
