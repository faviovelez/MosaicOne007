class AddSellerToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :seller_user, index: true
    add_reference :movements, :buyer_user, index: true
  end
end
