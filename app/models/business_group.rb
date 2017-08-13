class BusinessGroup < ActiveRecord::Base
  has_many :business_units
  has_many :business_group_sales
  has_many :warehouses
end
