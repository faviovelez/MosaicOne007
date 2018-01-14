class BillMailer < ApplicationMailer

  default from: "facturas@plataforma-dc.com"
  layout 'mailer'

  def send_bill_files(bill)
    @mails = ['favio.velez@hotmail.com', 'faviovelez29@gmail.com']
#    mail = bill.receiving_company.prospects.first.email
#    mail_2 = bill.receiving_company.prospects.first.email_2
#    mail_3 = bill.receiving_company.prospects.first.email_3
#    @mails << mail unless (mail == nil || mail == '')
#    @mails << mail_2 unless (mail_2 == nil || mail_2 == '')
#    @mails << mail_3 unless (mail_3 == nil || mail_3 == '')
    attachments['Factura.pdf'] = File.read(bill.pdf_url)
    attachments['Factura.xml'] = File.read(bill.xml_url)
      mail(
        bcc: @mails,
        subject: "Facturas Diseños de Cartón"
      )
  end

end
