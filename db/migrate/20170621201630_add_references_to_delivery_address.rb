class AddReferencesToDeliveryAddress < ActiveRecord::Migration
  def change
    add_column :delivery_addresses, :additional_references, :text
  end
end
