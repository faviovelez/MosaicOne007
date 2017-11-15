class AddCertificateNumberToBillingAddress < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :certificate_number, :string
  end
end
