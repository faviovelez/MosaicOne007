class Payment < ActiveRecord::Base
  # Tabla para guardar los pagos a las facturas recibidas
  belongs_to :bill_received
  belongs_to :supplier
  belongs_to :ticket
  belongs_to :bill
  belongs_to :user
  has_many :expenses
  belongs_to :terminal
  belongs_to :store
  belongs_to :business_unit
  belongs_to :payment_form
  belongs_to :bank
end
