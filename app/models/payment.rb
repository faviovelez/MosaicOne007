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
  has_one :date_advise
  belongs_to :payment_bill, class_name: 'Bill', foreign_key: 'payment_bill_id'

  before_update :create_update_summary

  after_create :save_web_id_and_set_web_true, :create_update_date_advise, :add_to_bill

  after_create :update_parent_status, if: :has_parent_and_is_not_payed

  # Crear o modificar objeto y si pertenece al mismo ticket dejar solo uno y borrar los demás (borrar los viejos)
  # Buscar y modificar los que pertenezcan al mismo ticket y desactivarlas y/o borrarlas (DateAdvise) ON CREATE Y ON UPDATE?

  def dont_exist_date_advise
    @parent = false
    @ticket = self.ticket
    unless @ticket == nil
      if @ticket.parent == nil
        !!(DateAdvise.where(ticket: @ticket).first.nil?)
      else
        @parent = true
        !!(DateAdvise.where(ticket: @ticket.parent).first.nil?)
      end
    end
  end

  def update_parent_status
    total_pay = 0
    total = 0
    parent = self.ticket.parent
    total += parent.store_movements.where(movement_type: 'venta').sum(:total)
    total -= parent.store_movements.where(movement_type: 'devolución').sum(:total)
    total += parent.service_offereds.where(service_type: 'venta').sum(:total)
    total -= parent.service_offereds.where(service_type: 'devolución').sum(:total)
    total_pay += parent.payments.where(payment_type: 'pago').sum(:total)
    children = parent.children
    children.each do |child|
      total += child.store_movements.where(movement_type: 'venta').sum(:total)
      total -= child.store_movements.where(movement_type: 'devolución').sum(:total)
      total += child.service_offereds.where(service_type: 'venta').sum(:total)
      total -= child.service_offereds.where(service_type: 'devolución').sum(:total)
      total_pay += child.payments.where(payment_type: 'pago').sum(:total)
      total_pay -= child.payments.where(payment_type: 'devolución').sum(:total)
    end
    parent.update(payed: true) if total - total_pay < 1
    if parent.bill != nil
      self.ticket.payments.each do |pay|
        parent.bill.payments << pay
      end
    end
  end

  def has_parent_and_is_not_payed
    self.ticket.present? && self.ticket.parent.present? && !self.ticket.parent.payed
  end

  def add_to_bill
    if self.ticket != nil
      self.update(bill: self.ticket.bill) if (self.ticket != nil && self.ticket.bill != nil && self.payment_type != 'cancelado')
      if self.ticket.parent.present? && self.ticket.parent.bill.present?
        self.update(bill_id: self.ticket.parent.bill_id) if self.payment_type != 'cancelado'
        self.ticket.parent.update(bill_id: self.ticket.parent.bill_id) if self.ticket.parent.ticket_type != 'cancelado'
      end
    end
  end

  def create_update_date_advise
    if dont_exist_date_advise
      create_date_advise unless @parent
    else
      update_date_advise unless @ticket.nil?
    end
  end

  def create_date_advise
    ticket = @ticket
    results = find_balance(@ticket)
    balance = results[:total] - results[:payments]
    if balance > 1 && self.payment_type == 'crédito'
      if ticket.prospect == nil
        DateAdvise.create(ticket: ticket, date: results[:date], before_date: results[:date] - self.store.days_before.days, after_date: results[:date] + results[:days].days + self.store.days_after.days, payment: self)
      else
        DateAdvise.create(ticket: ticket, date: results[:date], before_date: results[:date] - self.store.days_before.days, after_date: results[:date] + results[:days].days + self.store.days_after.days, payment: self, prospect: ticket.prospect)
      end
    end
  end

  def update_date_advise
    if @ticket.parent == nil
      advise = DateAdvise.where(ticket: @ticket).first
      ticket = @ticket
    else
      advise = DateAdvise.where(ticket: @ticket.parent).first
      ticket = @ticket.parent
    end
    results = find_balance(ticket)
    balance = results[:total] - results[:payments]
    if balance < 1
      advise.update(active: false, date: results[:date], before_date: results[:date] - self.store.days_before.days, after_date: results[:date] + results[:days].days + self.store.days_after.days, payment: self)
    else
      advise.update(active: true, date: results[:date], before_date: results[:date] - self.store.days_before.days, after_date: results[:date] + results[:days].days + self.store.days_after.days, payment: self)
    end
  end

  def find_balance(ticket)
    credit_payments = []
    @results = {payments: 0.0, total: 0.0, date: '', days: 0}
    ticket.payments.each do |pay|
      @results[:payments] += pay.total.to_f if pay.payment_type == 'pago'
      @results[:payments] -= pay.total.to_f if pay.payment_type == 'devolución'
      if pay.payment_type == 'crédito'
        credit = pay.credit_days.to_i
        credit_payments << [pay.created_at, pay.credit_days.to_i, pay.created_at.to_date + credit.days] unless credit_payments.include?(pay)
      end
    end
    ticket.store_movements.each do |sm|
      @results[:total] += sm.total if sm.movement_type == 'venta'
      @results[:total] -= sm.total if sm.movement_type == 'devolución'
    end
    ticket.service_offereds.each do |so|
      @results[:total] += so.total if so.service_type == 'venta'
      @results[:total] -= so.total if so.service_type == 'devolución'
    end
    ticket.children.each do |t|
      t.store_movements.each do |sm|
        @results[:total] += sm.total if sm.movement_type == 'venta'
        @results[:total] -= sm.total if sm.movement_type == 'devolución'
      end
      t.service_offereds.each do |so|
        @results[:total] += so.total if so.service_type == 'venta'
        @results[:total] -= so.total if so.service_type == 'devolución'
      end
      t.payments.each do |pay|
        @results[:payments] += pay.total.to_f if pay.payment_type == 'pago'
        @results[:payments] -= pay.total.to_f if pay.payment_type == 'devolución'
        if pay.payment_type == 'crédito'
          credit = pay.credit_days.to_i
          credit_payments << [pay.created_at, pay.credit_days.to_i, pay.created_at.to_date + credit.days] unless credit_payments.include?(pay)
        end
      end
    end
    if credit_payments != []
      credit_payments.sort! do |a, b|
        a[0] <=> b[0]
      end
      @results[:date] = credit_payments.last[2]
      @results[:days] = credit_payments.last[1]
    end

    return @results
  end

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
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
      if (changes['payment_type'][0] == 'pago' && self.payment_type == 'cancelado')
        StoreSale.create(payments: self.total * (-1), store: self.store, month: self.created_at.month, year: self.created_at.year)
      elsif (changes['payment_type'][0] == 'devolución' && self.payment_type == 'cancelado')
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
      if (changes['payment_type'][0] == 'pago' && self.payment_type == 'cancelado')
        sale.update(payments: sale.payments.to_f - total)
      elsif (changes['payment_type'][0] == 'devolución' && self.payment_type == 'cancelado')
        sale.update(payments: sale.payments.to_f + total)
      end
    end
  end

end
