class Payment < ActiveRecord::Base
  # Tabla para guardar los pagos a las facturas recibidas
  belongs_to :bill_received
  belongs_to :supplier
  has_one :ticket
  belongs_to :bill
end
