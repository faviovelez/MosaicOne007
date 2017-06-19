class AddBillingToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :billing_address, index: true, foreign_key: true
  end
end
