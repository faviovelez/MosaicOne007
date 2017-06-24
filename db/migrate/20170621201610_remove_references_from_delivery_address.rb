class RemoveReferencesFromDeliveryAddress < ActiveRecord::Migration
  def change
    remove_column :delivery_addresses, :additional_references, :string
  end
end
