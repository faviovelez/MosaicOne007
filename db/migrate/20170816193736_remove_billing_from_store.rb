class RemoveBillingFromStore < ActiveRecord::Migration
  def change
    remove_reference :stores, :billing_address, index: true, foreign_key: true
  end
end
