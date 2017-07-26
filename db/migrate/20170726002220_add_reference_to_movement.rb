class AddReferenceToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :product_request, index: true, foreign_key: true
  end
end
