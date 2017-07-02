class AddSomeToDeliveryAddress < ActiveRecord::Migration
  def change
    add_reference :delivery_addresses, :store, index: true, foreign_key: true
  end
end
