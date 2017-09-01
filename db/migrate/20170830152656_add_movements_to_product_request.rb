class AddMovementsToProductRequest < ActiveRecord::Migration
  def change
    add_reference :product_requests, :movement, index: true, foreign_key: true
    add_reference :product_requests, :pending_movement, index: true, foreign_key: true
  end
end
