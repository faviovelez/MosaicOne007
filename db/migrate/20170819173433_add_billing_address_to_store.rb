class AddBillingAddressToStore < ActiveRecord::Migration
  def change
    add_reference :stores, :billing_address, index: true, foreign_key: true
  end
end
