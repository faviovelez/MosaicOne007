class ChangeZipcodeFromBillingAddress < ActiveRecord::Migration
  def change
    change_column :billing_addresses, :zipcode, :string
  end
end
