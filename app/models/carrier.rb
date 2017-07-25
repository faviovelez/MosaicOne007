class Carrier < ActiveRecord::Base
  # Este modelo debe guardar a todas las paqueterías o fleteras a quienes se puede entregar producto a peticion de la store.
  has_many :orders
  belongs_to :delivery_address
end
