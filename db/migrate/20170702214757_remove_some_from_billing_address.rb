class RemoveSomeFromBillingAddress < ActiveRecord::Migration
  def change
    remove_reference :billing_addresses, :prospect, index: true, foreign_key: true
    remove_reference :billing_addresses, :store, index: true, foreign_key: true
  end
end
