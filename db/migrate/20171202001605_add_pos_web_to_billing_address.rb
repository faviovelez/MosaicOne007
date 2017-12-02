class AddPosWebToBillingAddress < ActiveRecord::Migration
  def change
    add_column :billing_addresses, :pos, :boolean, default: false
    add_column :billing_addresses, :web, :boolean, default: true
    add_column :billing_addresses, :date, :date
  end
end
