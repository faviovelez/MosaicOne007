class AddUploadFieldsToBillingAddress < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :certificate, :string
    add_column :billing_addresses, :key, :string
  end
end
