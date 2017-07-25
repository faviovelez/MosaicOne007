class BillReceived < ActiveRecord::Base
  # Tabla que registra las facturas recibidas
  belongs_to :supplier
  belongs_to :product
  has_many :payments
end
