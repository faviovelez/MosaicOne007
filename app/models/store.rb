class Store < ActiveRecord::Base
  # Para crear o modificar nuevas tiendas.
  has_many :users
  has_many :requests
  has_many :prospects
  has_many :orders
  has_many :movements
  has_many :pending_movements
  belongs_to :delivery_address
  belongs_to :billing_address
  has_many :store_sales
end
