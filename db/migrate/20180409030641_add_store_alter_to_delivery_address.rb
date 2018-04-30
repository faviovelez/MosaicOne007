class AddStoreAlterToDeliveryAddress < ActiveRecord::Migration
  def change
    add_reference :delivery_addresses, :store_alter, index: true
  end
end
