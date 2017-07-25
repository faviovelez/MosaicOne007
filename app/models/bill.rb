class Bill < ActiveRecord::Base
  # Este modelo debe contener todo lo relacionado a las facturas
  has_many :products_bills
  has_many :products, through: :products_bills
  belongs_to :order
  has_many :movements
  has_many :pending_movements
end
