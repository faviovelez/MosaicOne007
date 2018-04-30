class RemoveDeliveryAttemptFromOrder < ActiveRecord::Migration
  def change
    remove_reference :orders, :delivery_attempt, index: true, foreign_key: true
  end
end
