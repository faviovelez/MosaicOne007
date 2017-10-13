class RemoveDeliveryPackageFromMovement < ActiveRecord::Migration
  def change
    remove_reference :movements, :delivery_package, index: true, foreign_key: true
  end
end
