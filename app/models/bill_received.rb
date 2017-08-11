class BillReceived < ActiveRecord::Base
  # Tabla que registra las facturas recibidas
  belongs_to :supplier
  belongs_to :product
  has_many :payments

  before_create :set_taxes

  def set_taxes
    self.taxes = self.subtotal * (self.taxes_rate / 100)
  end
end
