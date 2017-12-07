module TicketsHelper

  def discount_percentage(summary)
    @discount_percentage = summary.discount / summary.total * 100
  end

  def margin_currency(summary)
    @margin_currency = summary.total - summary.cost
  end

  def margin_percentage(summary)
    margin_currency(summary)
    @margin_percentage = @margin_currency / summary.total * 100
  end

  def tickets_exists(month, year)
    store = current_user.store
    @ticket_true = store.tickets.where(
      'extract(month from created_at) = ? and extract(year from created_at) = ?',
      month, year
      ).where(tickets: {parent_id: nil}).count > 0
    @ticket_true
  end

  def bills_exists(month, year)
    store = current_user.store
    @bills_true = store.bills.where(
      'extract(month from created_at) = ? and extract(year from created_at) = ?',
      month, year
      ).where(relation_type: nil).where.not(pdf: nil, xml: nil).count > 0
    @bills_true
  end

  def consider_nc_and_dev_after_bill(month, year)
    @ncs_and_devs = store.bills.where(
      "sequence LIKE ? OR sequence LIKE ?",
      "%NC%", "%DE%"
      ).where(
        'extract(month from created_at) = ? and extract(year from created_at) = ?',
        month, year
        ).where.not(pdf: nil, xml: nil)
  end

  def get_payments_from_individual_ticket(ticket)
    get_total_with_returns_or_changes(ticket)
    payments = []
    payments << ticket.payments_amount
    ticket.children.each do |t|
        payments << t.payments_amount
    end
    payments = payments.inject(&:+)
    payments == nil ? @payments = 0 : @payments = payments
    @ticket_total <= @payments ? @pending = content_tag(:span, 'pagado', class: 'label label-success') : @pending = number_to_currency((@ticket_total - payments).round(2)).to_s
    @pending
  end

  def get_bill_status(ticket)
    ticket.bill != nil ? @bill_status = content_tag(:span, 'facturado', class: 'label label-success') : @bill_status = content_tag(:span, 'sin fact', class: 'label label-warning')
    @bill_status
  end

  def bill_has_nc
  end

  def bill_has_dev
  end

end
