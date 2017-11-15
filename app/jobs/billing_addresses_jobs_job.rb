class BillingAddressesJobsJob < ActiveJob::Base
  queue_as :default

  def perform(billing)
    @billing = billing
    save_certificate_number
  end

  def get_certificate_number
    file = File.join(Rails.root, "public", "uploads", "billing_address", "certificate", "#{@billing.id}", "cer.cer")
    serial = `openssl x509 -inform DER -in #{file} -noout -serial`
    n = serial.slice(7..46)
    @certificate_number = ''
    x = 1
    for i in 0..n.length
      if x % 2 == 0
        @certificate_number << n[i]
      end
      x += 1
    end
    @certificate_number
  end

  def save_certificate_number
    get_certificate_number
    @billing.update(certificate_number: @certificate_number)
  end

end
