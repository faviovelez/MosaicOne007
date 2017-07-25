class AddDeliveryToDeliveryPackage < ActiveRecord::Migration
  def change
    add_reference :delivery_packages, :delivery_attempt, index: true, foreign_key: true
  end
end
