class AddMovementToDeliveryAttempt < ActiveRecord::Migration
  def change
    add_reference :delivery_attempts, :movement, index: true, foreign_key: true
  end
end
