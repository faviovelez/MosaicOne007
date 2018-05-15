class CollectionMailer < ApplicationMailer

#  default from: "favio.velez@hotmail.com"
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

  def send_collection_before_mail(advice)
    @mails = []
    @advice = advice
    @ticket = advice.ticket
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

  def send_collection_mail(advice)
    @mails = []
    @advice = advice
    @ticket = advice.ticket
    mail = advice.store.bill_email
    address
    email
    store_tel
    webpage
    if advice.prospect != nil
      mail(
        to: mail,
        subject: "Hoy es la fecha límite de pago: #{advice.prospect.legal_or_business_name}, ticket #{advice.ticket.ticket_number}"
      )
    else
      mail(
        to: mail,
        subject: "Hoy es la fecha límite de pago: Público en General, ticket #{advice.ticket.ticket_number}"
      )
    end
  end

  def send_collection_after_mail(advice)
    @mails = []
    @advice = advice
    @ticket = advice.ticket
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
        subject: "El cliente Público en General tiene un adeudo en el ticket #{advice.ticket.ticket_number}"
      )
    end
  end

end
