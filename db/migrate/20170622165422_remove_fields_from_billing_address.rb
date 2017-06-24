class RemoveFieldsFromBillingAddress < ActiveRecord::Migration
  def change
    remove_column :billing_addresses, :type_of_bill, :string
    remove_column :billing_addresses, :bill_for_who, :string
    remove_column :billing_addresses, :classification, :string
  end
end
