class BillReceived < ActiveRecord::Base
  # Tabla que registra las facturas recibidas
  belongs_to :supplier
  has_many :products_bills_receiveds
  has_many :products, through: :products_bills_receiveds
  belongs_to :store
  has_many :payments
  has_many :documents

  before_create :set_taxes

  def set_taxes
    taxes = self.taxes_rate
    if taxes == nil
      self.taxes_rate == 16
    end
    self.taxes = self.subtotal * (self.taxes_rate / 100)
  end
end
