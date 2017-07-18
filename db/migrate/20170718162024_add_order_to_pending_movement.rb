class AddOrderToPendingMovement < ActiveRecord::Migration
  def change
    add_reference :pending_movements, :order, index: true, foreign_key: true
  end
end
