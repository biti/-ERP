class Property < ActiveRecord::Base

  has_many :property_values
  accepts_nested_attributes_for :property_values

end