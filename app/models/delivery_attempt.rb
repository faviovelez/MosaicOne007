class DeliveryAttempt < ActiveRecord::Base
  # Para registrar los intentos de entrega (porque puede haber más de un intento para una order, dependiendo si no todos los 'product_request' de la 'order' tienen el mismo grado de urgencia)
  belongs_to :product_request
  belongs_to :movement
  has_one :order
  has_many :delivery_packages
  belongs_to :driver
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
end
