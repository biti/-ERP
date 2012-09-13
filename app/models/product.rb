# -*- encoding : utf-8 -*-

require 'paipai'

class Product < ActiveRecord::Base

  has_one :content, :class_name => 'ProductContent', :foreign_key => 'product_id'
  accepts_nested_attributes_for :content

  has_many :skus
  accepts_nested_attributes_for :skus
  
  has_many :properties
  accepts_nested_attributes_for :properties
  
  belongs_to :partner
  belongs_to :category

  validates_presence_of :name, :title, :price, :market_price, :custom_id, :num
  validates_uniqueness_of :custom_id, :scope => :partner_id
  validates_numericality_of :market_price, :greater_than => 0, :message => '必须大于0'
  validates_numericality_of :price, :greater_than => 0, :less_than_or_equal_to => :market_price, :message => '必须小于或等于商场价，并且大于0'
  
  validate do |record|
    record.errors[:base] << "至少要录入一款sku" if skus.empty?
  end
  
  # 集成上传模块
  mount_uploader :image1, ProductImageUploader
  mount_uploader :image2, ProductImageUploader
  mount_uploader :image3, ProductImageUploader
  mount_uploader :image4, ProductImageUploader
  mount_uploader :image5, ProductImageUploader
  
  STATUS = {
    :onsale => {
      :name => '出售中',
      :value => 10,
    },
    :instock => {
      :name => '仓库中',
      :value => 20,
    },
    :sale_on_time => {
      :name => '定时上架',
      :value => 30,
    }
  }
  
  STATUS_MAPPING = {
    :taobao => {
      'onsale' => 10,
      'instock' => 20,
    },
    :paipai => {
      'IS_FOR_SALE' => 10,
      'IS_IN_STORE' => 20,
      'IS_SALE_ON_TIME' => 30,
    },
    :jingdong => {
      
    },
  }
  
  def build_properties_values
    property1 = properties.build(:name => '颜色')
    ['红色', '绿色', '蓝色', '黑色', '黄色', '白色'].each do |name|
      property1.property_values.build :name => name
    end
  
    property2 = properties.build(:name => '尺码')
    ['XS', 'S', 'M', 'L', 'XL', 'XXL', '均码'].each do |name|
      property2.property_values.build :name => name
    end
  end
  
  class << self
    
    def shortage
      order("id DESC")
    end
    
  end
  
  
end
