class BusinessGroup < ActiveRecord::Base
# Agrupa las razones sociales (Business Units) que pertenecen al mismo dueño o grupo
  has_many :business_units
  has_many :business_group_sales
  has_many :warehouses
  has_many :suppliers, through: :business_groups_suppliers
  has_many :business_groups_suppliers
  has_many :prospects
  has_many :stores
end
