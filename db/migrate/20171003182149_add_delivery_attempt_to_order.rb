class AddDeliveryAttemptToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :delivery_attempt, index: true, foreign_key: true
  end
end
