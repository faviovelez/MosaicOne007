class AddSaleAndEntryMovementToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :entry_movement, index: true
  end
end
