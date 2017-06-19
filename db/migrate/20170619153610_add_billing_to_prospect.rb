class AddBillingToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :billing_address, index: true, foreign_key: true
  end
end
