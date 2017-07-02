class AddSomeToBillingAddress < ActiveRecord::Migration
  def change
    add_reference :billing_addresses, :prospect, index: true, foreign_key: true
    add_reference :billing_addresses, :store, index: true, foreign_key: true
  end
end
