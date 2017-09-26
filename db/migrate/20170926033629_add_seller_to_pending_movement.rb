class AddSellerToPendingMovement < ActiveRecord::Migration
  def change
    add_reference :pending_movements, :seller_user, index: true
    add_reference :pending_movements, :buyer_user, index: true
  end
end
