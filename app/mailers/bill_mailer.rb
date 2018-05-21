class BillMailer < ApplicationMailer

  default from: "facturas@plataforma-dc.com"
  #  default from: "faviovelez29@gmail.com"

  layout 'mailer'

  def address
    store = @bill.store
    @address = store.delivery_address.street + ' ' + store.delivery_address.exterior_number + ', '
    @address += 'Int. ' + store.delivery_address.interior_number + ' ' unless store.delivery_address.interior_number.blank?
    @address += 'Col. ' + store.delivery_address.neighborhood + '.' + ' ' + store.delivery_address.city + ',' + ' ' + store.delivery_address.state
    @address = @address.split.map(&:capitalize)*' '
    @address
  end

  def email
    @store_email = @bill.store.email
  end

  def store_tel
    @store_tel = @bill.store.direct_phone
  end

  def webpage
    @store_webpage = 'www.disenosdecarton.com.mx'
  end

  def send_bill_files(bill)
    @mails = []
    @bill = bill
    mail = bill.receiving_company.prospects.first.email
    mail_2 = bill.receiving_company.prospects.first.email_2
    mail_3 = bill.receiving_company.prospects.first.email_3
    address
    email
    store_tel
    webpage
    @mails << mail unless (mail == nil || mail == '')
    @mails << mail_2 unless (mail_2 == nil || mail_2 == '')
    @mails << mail_3 unless (mail_3 == nil || mail_3 == '')
    @mails << bill.store.bill_email
    attachments['Factura.pdf'] = open(bill.pdf_url).read
    attachments['Factura.xml'] = open(bill.xml_url).read
      mail(
        bcc: @mails,
        subject: "Facturas Diseños de Cartón"
      )
  end

end
