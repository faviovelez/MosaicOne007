class AddReceiversZipcodeToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :receivers_zipcode, :string
  end
end
