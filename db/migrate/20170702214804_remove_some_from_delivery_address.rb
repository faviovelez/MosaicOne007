class RemoveSomeFromDeliveryAddress < ActiveRecord::Migration
  def change
    remove_reference :delivery_addresses, :prospect, index: true, foreign_key: true
    remove_reference :delivery_addresses, :store, index: true, foreign_key: true
  end
end
