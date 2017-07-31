class AddDeliveryPackageToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :delivery_package, index: true, foreign_key: true
  end
end
