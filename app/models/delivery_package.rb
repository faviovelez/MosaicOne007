class DeliveryPackage < ActiveRecord::Base
  # Este modelo es para los paquetes finales en los que se entrega la mercancía (una o más cajas que contienen x cantidad de piezas del 'product_request' de la 'order')
  has_many :product_requests
  has_many :movements
  belongs_to :delivery_attempt
  belongs_to :order
  belongs_to :delivery_package
end
