class AddOrderToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :order, index: true, foreign_key: true
  end
end
