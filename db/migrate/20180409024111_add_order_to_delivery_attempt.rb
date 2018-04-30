class AddOrderToDeliveryAttempt < ActiveRecord::Migration
  def change
    add_reference :delivery_attempts, :order, index: true, foreign_key: true
  end
end
