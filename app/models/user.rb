# encoding: utf-8

class User < ActiveRecord::Base

  ROLES = {
    :default => 0,
    :admin => 10,
  }
  
  PERMISSIONS = {
    :edit_bill    => '录单', 
    :audit        => '审核',
    :edit         => '编辑',
    #:audit_sample => '样品审核',
    #:user_manage  => '用户管理',
  }
  
  PERMISSIONS.keys.each do |key|
    define_method "can_#{key}?" do
      permissions.to_s.split(',').include? key.to_s
    end
  end
  
  attr_accessor :password_confirmation

  validates_presence_of :username, :password, :register_code, :phone
  validates_uniqueness_of :username
  validates_length_of :username, :within => 4..20, 
    :too_long => "太长，最多20位", :too_short => "太短，最少4位"
  validates_length_of :password, :within => 6..20, 
    :too_long => "太长，最多20位", :too_short => "太短，最少6位"
  
  validates :password, :confirmation => true
  validates :password_confirmation, :presence => true

  has_one :setting, :class_name => 'UserSetting', :foreign_key => 'user_id'
  has_many :shops
  has_many :delivery_templates, :class_name => 'DeliveryTemplate'
  has_many :products
  has_many :skus
  has_many :orders
  has_many :customers
  has_many :delivery_templates
  has_many :day_datas
  
  validate do
    errors.add(:register_code, "不正确") unless RegisterCode.valid?(register_code)
  end
  
  before_create do
    generate_password
  end
  
  after_create do
    PLATFORMS.each do |key, value|
      Shop.create(:platform_id => value[:id], :user_id => self.id, :shop_name => value[:name])
    end
    
    RegisterCode.find_by_code(register_code).update_attribute(:is_available, :false)
    UserSetting.create(:user_id => id, :status => 'new_user')
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
    def valid_by_username_and_password?(username, password)
      user = find_by_username(username)
      return false unless user

      user.password == Digest::MD5.hexdigest("#{password}#{user.salt}") ? user : false
    end
    
  end
end
