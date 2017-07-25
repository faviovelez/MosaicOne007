class AddCarrierToDeliveryAddress < ActiveRecord::Migration
  def change
    add_reference :delivery_addresses, :carrier, index: true, foreign_key: true
  end
end
