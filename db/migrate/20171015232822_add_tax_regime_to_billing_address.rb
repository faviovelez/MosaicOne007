class AddTaxRegimeToBillingAddress < ActiveRecord::Migration
  def change
    add_reference :billing_addresses, :tax_regime, index: true, foreign_key: true
  end
end
