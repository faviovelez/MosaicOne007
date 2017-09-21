class BusinessUnit < ActiveRecord::Base
  # Agrupa las tiendas que pertenecen a la misma razón social
  has_many :business_unit_sales
  has_many :movements
  has_many :pending_movements
  belongs_to :business_group
  has_many :prospects
  has_many :products
  has_many :stores
  belongs_to :billing_address
  has_many :warehouses
  has_many :bills
  has_many :discount_rules
end
