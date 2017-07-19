class DeliveryPackage < ActiveRecord::Base
  # Este modelo es para los paquetes finales en los que se entrega la mercancía (una o más cajas que contienen x cantidad de piezas del producto x del pedido)
  belongs_to :order
end
