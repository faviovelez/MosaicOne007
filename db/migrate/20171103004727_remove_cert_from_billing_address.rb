class RemoveCertFromBillingAddress < ActiveRecord::Migration
  def change
    remove_column :billing_addresses, :certificate, :string
    remove_column :billing_addresses, :key, :string
    remove_column :billing_addresses, :certificate_password, :string
    remove_column :billing_addresses, :certificate_number, :string
  end
end
