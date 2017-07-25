class DeliveryAddress < ActiveRecord::Base
  # Este modelo debe guardar todas las direcciones de entrega.
  has_many :orders
  has_many :stores
  has_many :prospects
  has_one :carrier
end
