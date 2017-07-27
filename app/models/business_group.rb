class BusinessGroup < ActiveRecord::Base
  has_many :business_units
end
