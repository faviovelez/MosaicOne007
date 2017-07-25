class RemoveCarrierFromDeliveryAddress < ActiveRecord::Migration
  def change
    remove_reference :delivery_addresses, :carrier, index: true, foreign_key: true
  end
end
