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
    ticket_true = store.tickets.where('extract(month from created_at) = ? and extract(year from created_at) = ?', month, year).where(tickets: {parent_id: nil}).count > 0
    @ticket_true
  end

  def bills_exists(month, year)
    store = current_user.store
    bills_true = store.bills.where('extract(month from created_at) = ? and extract(year from created_at) = ?', month, year).where(relation_type: nil).where.not(pdf: nil, xml: nil).count > 0
    @bills_true
  end

end
