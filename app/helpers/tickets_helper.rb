module TicketsHelper

  def discount_percentage(summary)
    @discount_percentage = summary.discount / summary.total * 100
    @discount_percentage.nan? ? @discount_percentage = 0 : @discount_percentage
    @discount_percentage
  end

  def margin_currency(summary)
    @margin_currency = (summary.total - (summary.cost * 1.16).round(2))
  end

  def margin_percentage(summary)
    margin_currency(summary)
    @margin_percentage = @margin_currency / summary.total * 100
    @margin_percentage.nan? ? @margin_percentage = 0 : @margin_percentage
    @margin_percentage
  end

  def tickets_exists(month, year)
    store = current_user.store
    @ticket_true = store.tickets.where(
      'extract(month from created_at) = ? and extract(year from created_at) = ?',
      month, year
      ).where(tickets: {parent_id: nil}).count > 0
    @ticket_true
  end

  def convert_total(object)
    if object.class == Hash
      if object["type"] == 'devolución'
        @total = -object["total"]
      elsif object["type"] == 'venta'
        @total = object["total"]
      else
        @total = 0
      end
    elsif object.class == Payment
      if object.payment_type == 'devolución'
        @total = -object.total
      elsif object.payment_type == 'venta'
        @total = object.total
      else
        @total = 0
      end
    end
    @total
  end

  def payments_of_ticket(ticket)
    @all_payments_of_ticket = 0
    ticket.payments.each do |pay|
      @all_payments_of_ticket += pay.total if pay.payment_type == 'pago'
      @all_payments_of_ticket -= pay.total if pay.payment_type == 'devolución'
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

  def rows_for_ticket_show_helper(ticket)
    @rows = []
    ticket.store_movements.each do |movement|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = movement.ticket.id
        hash["ticket_number"] = movement.ticket.ticket_number
        hash["type"] = movement.movement_type
        hash["date"] = movement.created_at.to_date
        hash["unique_code"] = movement.product.unique_code
        hash["description"] = movement.product.description
        hash["color"] = movement.product.exterior_color_or_design
        hash["unit_value"] = movement.initial_price.to_f
        hash["quantity"] = movement.quantity.to_i
        hash["discount"] = movement.discount_applied.to_f
        hash["total"] = movement.total.to_f
        hash["subtotal"] = movement.subtotal.to_f
        hash["taxes"] = movement.taxes.to_f
        hash["discount"] = movement.discount_applied.to_f
      end
      @rows << hash
    end
    ticket.service_offereds.each do |service|
      hash = Hash.new.tap do |hash|
        hash["ticket"] = service.ticket.id
        hash["ticket_number"] = service.ticket.ticket_number
        hash["type"] = service.service_type
        hash["date"] = service.created_at.to_date
        hash["unique_code"] = service.service.unique_code
        hash["description"] = service.service.description
        hash["unit_value"] = service.initial_price.to_f
        hash["quantity"] = service.quantity.to_i
        hash["discount"] = service.discount_applied.to_f
        hash["total"] = service.total.to_f
        hash["subtotal"] = service.subtotal.to_f
        hash["taxes"] = service.taxes.to_f
        hash["discount"] = service.discount_applied.to_f
      end
      @rows << hash
    end
    @total_rows_ticket = 0
    @rows.each do |row|
      if row["type"] == 'venta'
        @total_rows_ticket += row["total"]
      elsif row["type"] == 'devolución'
        @total_rows_ticket -= row["total"]
      end
    end
    @total_rows_ticket
    @rows
  end

  def payments_for_ticket_show(ticket)
    @payments_ticket = []
    @total_payments_ticket = 0
    ticket.payments.each do |payment|
      unless payment.payment_type == 'crédito'
        @payments_ticket << payment
        if payment.payment_type == 'pago'
          @total_payments_ticket += payment.total
        elsif payment.payment_type == 'devolución'
          @total_payments_ticket -= payment.total
        end
      end
    end
    ticket.children.each do |t|
      t.payments.each do |payment|
        unless payment.payment_type == 'crédito'
          @payments_ticket << payment
          if payment.payment_type == 'pago'
            @total_payments_ticket += payment.total
          elsif payment.payment_type == 'devolución'
            @total_payments_ticket -= payment.total
          end
        end
      end
    end
    @total_payments_ticket
  end

  def get_payments_on_sales_summary(ticket)
    rows_for_ticket_show_helper(ticket)
    payments_for_ticket_show(ticket)
  (@total_rows_ticket <= @total_payments_ticket || @total_rows_ticket - @total_payments_ticket < 1) ? @pending = content_tag(:span, 'pagado', class: 'label label-success') : @pending = number_to_currency(@total_rows_ticket - @total_payments_ticket)
    @pending
  end

  def get_payments_from_individual_ticket(ticket)
    (@total_rows_ticket <= @total_payments_ticket || @total_rows_ticket - @total_payments_ticket < 1) ? @pending = content_tag(:span, 'pagado', class: 'label label-success') : @pending = number_to_currency(@total_rows_ticket - @total_payments_ticket)
    @pending
  end

end
