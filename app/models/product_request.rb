class ProductRequest < ActiveRecord::Base
  # Tabla para guardar el estatus de entrega indidividual de cada producto, así como el nivel de urgencia y fecha máxima de entrega (para poder hacer entregas parciales de una 'Order')
  belongs_to :product
  belongs_to :order
  belongs_to :delivery_package
  belongs_to :movement
  belongs_to :pending_movement
end
