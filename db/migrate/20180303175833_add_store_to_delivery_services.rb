class AddStoreToDeliveryServices < ActiveRecord::Migration
  def change
    add_reference :delivery_services, :store, index: true, foreign_key: true
  end
end
