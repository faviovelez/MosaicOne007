class BusinessUnit < ActiveRecord::Base
  # Agrupa las tiendas que pertenecen al mismo dueño para generar reportes agrupados.
  has_many :business_unit_sales
  has_many :movements
  has_many :pending_movements
  belongs_to :business_group
  has_many :prospects
  has_many :products
  has_many :stores
  belongs_to :billing_address
  has_many :warehouses
end
