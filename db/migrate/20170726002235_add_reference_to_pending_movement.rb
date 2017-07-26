class AddReferenceToPendingMovement < ActiveRecord::Migration
  def change
    add_reference :pending_movements, :product_request, index: true, foreign_key: true
  end
end
