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

  before_update :create_update_summary

  after_create :save_web_id

  after_create :update_web_true

  def save_web_id
    self.update(web_id: self.id)
  end

  def update_web_true
    self.update(web: true)
  end

  def create_update_summary
    if dont_exist_store_sale
      create_only_payments
    else
      update_only_payments
    end
  end

  def dont_exist_store_sale
    !!(StoreSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: self.store).first.nil?)
  end

  def create_only_payments
    if id_changed?
      if self.payment_type == 'pago'
        StoreSale.create(payments: self.total, store: self.store, month: self.created_at.month, year: self.created_at.year)
      else
        StoreSale.create(payments: self.total * (-1), store: self.store, month: self.created_at.month, year: self.created_at.year)
      end
    elsif (!id_changed? && changes['payment_type'] != nil)
      if (changes['payment_type'][0] == 'pago' && self.movement_type == 'cancelado')
        StoreSale.create(payments: self.total * (-1), store: self.store, month: self.created_at.month, year: self.created_at.year)
      elsif (changes['payment_type'][0] == 'devolución' && self.movement_type == 'cancelado')
        StoreSale.create(payments: self.total, store: self.store, month: self.created_at.month, year: self.created_at.year)
      end
    end
  end

  def update_only_payments
    sale = StoreSale.where(month: self.created_at.to_date.month, year: self.created_at.to_date.year, store: self.store).first
    total = self.total
    if id_changed?
      if self.payment_type == 'pago'
        sale.update(payments: sale.payments.to_f + total)
      elsif self.payment_type == 'devolución'
        sale.update(payments: sale.payments.to_f - total)
      end
    elsif (!id_changed? && changes['payment_type'] != nil)
      if (changes['payment_type'][0] == 'pago' && self.movement_type == 'cancelado')
        sale.update(payments: sale.payments.to_f - total)
      elsif (changes['payment_type'][0] == 'devolución' && self.movement_type == 'cancelado')
        sale.update(payments: sale.payments.to_f + total)
      end
    end
  end

end
