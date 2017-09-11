class RemoveMovementFromProductRequest < ActiveRecord::Migration
  def change
    remove_reference :product_requests, :movement, index: true, foreign_key: true
    remove_reference :product_requests, :pending_movement, index: true, foreign_key: true
  end
end
