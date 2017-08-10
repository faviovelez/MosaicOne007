class AddBillingToBusinessUnit < ActiveRecord::Migration
  def change
    add_reference :business_units, :billing_address, index: true, foreign_key: true
  end
end
