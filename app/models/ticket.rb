class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :tax
  belongs_to :prospect
  belongs_to :bill
  belongs_to :cash_register
  has_many :movements
  has_many :pending_movements
  has_many :store_movements
  has_many :service_offereds
  belongs_to :cfdi_use
  has_many :payments
  has_many :children, through: :tickets_child, foreign_key: 'children_id'
  has_many :tickets_child
  has_one :date_advise
  belongs_to :parent, class_name: 'Ticket', foreign_key: 'parent_id'

  after_create :save_web_id_and_set_web_true

  after_create :update_ticket_type_if_parent_cancelled

  def save_web_id_and_set_web_true
    self.update(web_id: self.id, web: true)
  end

  def update_ticket_type_if_parent_cancelled
    if self.parent != nil
      self.update(ticket_type: 'cancelado') if self.parent.ticket_type == 'cancelado'
    end
  end

  def sum_payments
    total = 0
    self.payments.each do |pay|
      if pay.payment_type == 'pago'
        total += pay.total
      elsif pay.payment_type == 'devolución'
        total -= pay.total
      end
    end
    self.children.each do |ticket|
      ticket.payments.each do |pay|
        if pay.payment_type == 'pago'
          total += pay.total
        elsif pay.payment_type == 'devolución'
          total -= pay.total
        end
      end
    end
    return total
  end

end
