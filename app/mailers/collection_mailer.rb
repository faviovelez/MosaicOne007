class CollectionMailer < ApplicationMailer

  default from: "notificaciones@plataforma-dc.com"
  #  default from: "faviovelez29@gmail.com"

  layout 'mailer'

  def address
    store = @advice.store
    @address = store.delivery_address.street + ' ' + store.delivery_address.exterior_number + ', '
    @address += 'Int. ' + store.delivery_address.interior_number + ' ' unless store.delivery_address.interior_number.blank?
    @address += 'Col. ' + store.delivery_address.neighborhood + '.' + ' ' + store.delivery_address.city + ',' + ' ' + store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
  end

  def email
    @store_email = @advice.store.email
  end

  def store_tel
    @store_tel = @advice.store.direct_phone
  end

  def webpage
    @store_webpage = 'www.disenosdecarton.com.mx'
  end

  def find_balance(ticket)
    @results = {payments: 0.0, total: 0.0}
    ticket.payments.each do |pay|
      @results[:payments] += pay.total.to_f if pay.payment_type == 'pago'
      @results[:payments] -= pay.total.to_f if pay.payment_type == 'devolución'
    end
    ticket.store_movements.each do |sm|
      @results[:total] += sm.total if sm.movement_type == 'venta'
      @results[:total] -= sm.total if sm.movement_type == 'devolución'
    end
    ticket.service_offereds.each do |so|
      @results[:total] += sm.total if so.service_type == 'venta'
      @results[:total] -= sm.total if so.service_type == 'devolución'
    end
    ticket.children.each do |t|
      t.store_movements.each do |sm|
        @results[:total] += sm.total if sm.movement_type == 'venta'
        @results[:total] -= sm.total if sm.movement_type == 'devolución'
      end
      t.service_offereds.each do |so|
        @results[:total] += sm.total if so.service_type == 'venta'
        @results[:total] -= sm.total if so.service_type == 'devolución'
      end
      t.payments.each do |pay|
        @results[:payments] += pay.total.to_f if pay.payment_type == 'pago'
        @results[:payments] -= pay.total.to_f if pay.payment_type == 'devolución'
      end
    end
    return @results
  end

 def send_collection_before_mail(advice)
   @mails = []
   @advice = advice
   @ticket = advice.ticket
   if !@ticket.payed
     find_balance(@ticket)
     @total = @results[:total]
     @payments = @results[:payments]
     @balance = @total - @payments
     if (@balance > 1 && @advice.active)
       mail = advice.store.bill_email
       address
       email
       store_tel
       webpage
       if advice.prospect != nil
         mail(
           to: mail,
           subject: "Fecha de vencimiento cercana: #{advice.prospect.legal_or_business_name}, ticket #{advice.ticket.ticket_number}"
         )
       else
         mail(
           to: mail,
           subject: "Fecha de vencimiento cercana: Público en General, ticket #{advice.ticket.ticket_number}"
         )
       end
     end
   end
 end

  def send_collection_mail(advice)
    @mails = []
    @advice = advice
    @ticket = advice.ticket
    if !@ticket.payed
      find_balance(@ticket)
      @total = @results[:total]
      @payments = @results[:payments]
      @balance = @total - @payments
      if (@balance > 1 && @advice.active)
        mail = advice.store.bill_email
        address
        email
        store_tel
        webpage
        if advice.prospect != nil
          mail(
            to: mail,
            subject: "Fecha límite de pago hoy: #{advice.prospect.legal_or_business_name}, ticket #{advice.ticket.ticket_number}"
          )
        else
          mail(
            to: mail,
            subject: "Fecha límite de pago hoy, ticket #{advice.ticket.ticket_number}"
          )
        end
      end
    end
  end

  def send_collection_after_mail(advice)
    @mails = []
    @advice = advice
    @ticket = advice.ticket
    if !@ticket.payed
      find_balance(@ticket)
      @total = @results[:total]
      @payments = @results[:payments]
      @balance = @total - @payments
      if (@balance > 1 && @advice.active)
        mail = advice.store.bill_email
        address
        email
        store_tel
        webpage
        if advice.prospect != nil
          mail(
            to: mail,
            subject: "El cliente #{advice.prospect.legal_or_business_name} tiene un adeudo en el ticket #{advice.ticket.ticket_number}"
          )
        else
          mail(
            to: mail,
            subject: "El ticket #{advice.ticket.ticket_number} tiene un saldo vencido"
          )
        end
      end
    end
  end

end
