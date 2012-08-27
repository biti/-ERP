# encoding: utf-8

class DeliveryTemplate < ActiveRecord::Base
  
  validates :template, :presence => true
  validates :name, :presence => true
  validates :width, :inclusion => { :in => 200..400, :message => "必须在200mm-400mm之间"}
  validates :height, :inclusion => { :in => 100..300, :message => '必须在100mm-300mm之间'}
  
  belongs_to :user
  
  def human_default
    default ? '默认' : ''
  end
end
