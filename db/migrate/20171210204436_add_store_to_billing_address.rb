class AddStoreToBillingAddress < ActiveRecord::Migration
  def change
    add_reference :billing_addresses, :store, index: true, foreign_key: true
  end
end
