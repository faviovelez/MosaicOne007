class Product < ActiveRecord::Base
  # Catálogo de productos para todos los usuarios.
  has_many :images
  has_many :movements
  has_many :pending_movements
  has_one :inventory
  has_many :bill_receiveds
  has_many :products_bills
  has_many :bills, through: :products_bills
  has_many :product_requests
  has_many :product_sales
  belongs_to :business_unit
  has_many :production_requests
  has_one :request
end
