# encoding: utf-8

class Partner < ActiveRecord::Base

  ROLES = {
    :default => 0,
    :admin => 10,
  }
  
  PERMISSIONS = {
    :edit_bill    => '录单', 
    :audit        => '审核',
    :edit         => '编辑',
  }
  
  PERMISSIONS.keys.each do |key|
    define_method "can_#{key}?" do
      permissions.to_s.split(',').include? key.to_s
    end
  end
  
  attr_accessor :password_confirmation

  validates_presence_of :login, :password, :name
  validates_uniqueness_of :login
  validates_length_of :login, :within => 4..20, 
    :too_long => "太长，最多20位", :too_short => "太短，最少4位"
  validates_length_of :password, :within => 6..20, 
    :too_long => "太长，最多20位", :too_short => "太短，最少6位"
  
  validates :password, :confirmation => true
  validates :password_confirmation, :presence => true

  has_many :shops
  has_many :delivery_templates, :class_name => 'DeliveryTemplate'
  has_many :products
  has_many :skus
  has_many :orders
  has_many :customers
  has_many :delivery_templates
  has_many :day_datas
  
  before_create do
    generate_password
  end
  
  
  # 生成salt和密码
  def generate_password
    self.salt = SecureRandom.hex(4)
    self.password = Digest::MD5.hexdigest("#{password}#{salt}")
  end
  
  def need_init?
    setting.nil? or setting.status == 'new_user'
  end
  
  class << self

    # 验证
    def valid_by_login_and_password?(login, password)
      partner = find_by_login(login)
      return false unless partner

      partner.password == Digest::MD5.hexdigest("#{password}#{partner.salt}") ? partner : false
    end
    
  end
end
