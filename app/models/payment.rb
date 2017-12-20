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
  belongs_to :order

  after_create :create_update_summary

  def create_update_summary
    if (self.payment_type == 'pago' || self.payment_type == 'devolución')
      if dont_exist_store_sale
        create_only_payments
      else
        update_only_payments
      end
    end
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: Date.today.month, year: Date.today.year, store: self.store).first.nil?)
  end

  def create_only_payments
    if self.payment_type == 'pago'
      StoreSale.create(payments: self.total, store: self.store, month: self.created_at.month, year: self.created_at.year)
    else
      StoreSale.create(payments: self.total * (-1), store: self.store, month: self.created_at.month, year: self.created_at.year)
    end
  end

  def update_only_payments
    sale = StoreSale.where(month: Date.today.month, year: Date.today.year, store: self.store).first
    total = self.total
    if self.payment_type == 'pago'
      sale.update(payments: sale.payments.to_f + total)
    else
      sale.update(payments: sale.payments.to_f - total)
    end
  end

end
