class BusinessGroup < ActiveRecord::Base
  has_many :business_units
  has_many :business_group_sales
  has_many :warehouses
  has_many :suppliers, through: :business_groups_suppliers
  has_many :business_groups_suppliers
  has_many :prospects
  has_many :stores
end
