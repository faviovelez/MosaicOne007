class AddNameToDeliveryAddress < ActiveRecord::Migration
  def change
    add_column :delivery_addresses, :name, :string
  end
end
