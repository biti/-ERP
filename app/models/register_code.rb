class RegisterCode < ActiveRecord::Base
  
  class << self
    def valid?(code)
      !where(:code => code, :is_available => true).empty?
    end
  end
  
end
