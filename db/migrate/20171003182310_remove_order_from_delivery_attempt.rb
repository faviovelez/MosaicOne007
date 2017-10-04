class RemoveOrderFromDeliveryAttempt < ActiveRecord::Migration
  def change
    remove_reference :delivery_attempts, :order, index: true, foreign_key: true
  end
end
