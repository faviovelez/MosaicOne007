class AddCertificatePassToBillingAddress < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :certificate_password, :string
  end
end
