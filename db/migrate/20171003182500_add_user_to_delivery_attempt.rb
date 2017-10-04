class AddUserToDeliveryAttempt < ActiveRecord::Migration
  def change
    add_reference :delivery_attempts, :driver, index: true
    add_reference :delivery_attempts, :receiver, index: true
  end
end
