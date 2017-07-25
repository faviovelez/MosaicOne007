class Prospect < ActiveRecord::Base
  # Para todos los clientes o posibles clientes de cada tienda o del corporativo.
  belongs_to :store
  has_many :requests
  belongs_to :billing_address
  belongs_to :delivery_address
  belongs_to :user
  has_many :orders
  has_many :movements
  has_many :pending_movements
  has_many :prospect_sales
end
