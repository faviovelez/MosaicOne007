module TicketsHelper

  def discount_percentage(summary)
#    debugger
    @discount_percentage = summary.discount / summary.total * 100
  end

  def margin_currency(summary)
    @margin_currency = (summary.total - (summary.cost * 1.16).round(2))
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

  def payments_of_ticket(ticket)
    @all_payments_of_ticket = 0
    ticket.payments.each do |pay|
      @all_payments_of_ticket += pay.total
    end
    @all_payments_of_ticket
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
    @ticket_total <= @payments ? @pending = content_tag(:span, 'pagado', class: 'label label-success') : @pending = number_to_currency(@ticket_total - payments)
    @pending
  end

  def rows_for_ticket_show_helper(ticket)
    @rows = []
    ticket.store_movements.each do |movement|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = movement.ticket.id
        hash["type"] = movement.movement_type
        hash["date"] = movement.created_at.to_date
        hash["unique_code"] = movement.product.unique_code
        hash["description"] = movement.product.description
        hash["color"] = movement.product.exterior_color_or_design
        hash["unit_value"] = movement.initial_price
        hash["quantity"] = movement.quantity
        hash["subtotal"] = movement.subtotal
        hash["discount"] = movement.discount_applied
        hash["taxes"] = movement.taxes
        hash["total"] = movement.total
      end
      @rows << hash
    end
    ticket.service_offereds.each do |service|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = service.ticket.id
        hash["type"] = service.service_type
        hash["date"] = service.created_at.to_date
        hash["unique_code"] = service.service.unique_code
        hash["description"] = service.service.description
        hash["unit_value"] = service.initial_price
        hash["quantity"] = service.quantity
        hash["subtotal"] = service.subtotal
        hash["taxes"] = service.taxes
        hash["discount"] = service.discount_applied
        hash["total"] = service.total
      end
      @rows << hash
    end
    ticket.children.each do |t|
      t.store_movements.each do |movement|
        hash = Hash.new.tap do |hash|
          hash["ticket"] = movement.ticket.id
          hash["type"] = movement.movement_type
          hash["date"] = movement.created_at.to_date
          hash["unique_code"] = movement.product.unique_code
          hash["description"] = movement.product.description
          hash["color"] = movement.product.exterior_color_or_design
          hash["unit_value"] = movement.initial_price
          hash["quantity"] = movement.quantity
          hash["subtotal"] = movement.subtotal
          hash["discount"] = movement.discount_applied
          hash["taxes"] = movement.taxes
          hash["total"] = movement.total
        end
        @rows << hash
      end
      t.service_offereds.each do |service|
        hash = Hash.new.tap do |hash|
          hash["ticket"] = service.ticket.id
          hash["type"] = service.service_type
          hash["date"] = service.created_at.to_date
          hash["unique_code"] = service.service.unique_code
          hash["description"] = service.service.description
          hash["unit_value"] = service.initial_price
          hash["quantity"] = service.quantity
          hash["subtotal"] = service.subtotal
          hash["taxes"] = service.taxes
          hash["discount"] = service.discount_applied
          hash["total"] = service.total
        end
        @rows << hash
      end
    end
    @rows
  end


end
