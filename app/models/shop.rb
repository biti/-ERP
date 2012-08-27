class Shop < ActiveRecord::Base
  
  belongs_to :user
  
  scope :binded, where(:binded => true)
  
  def human_platform
    platform = PLATFORMS.values.find{|i| i[:id] == platform_id}
    "<span class='label' style='background-color:#{platform[:color]}'>#{platform[:name]}</span>"
  end
  
  
end
