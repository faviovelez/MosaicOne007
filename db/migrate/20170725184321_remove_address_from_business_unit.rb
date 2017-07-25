class RemoveAddressFromBusinessUnit < ActiveRecord::Migration
  def change
    remove_reference :business_units, :billing_address, index: true, foreign_key: true
    remove_reference :business_units, :delivery_address, index: true, foreign_key: true
  end
end
