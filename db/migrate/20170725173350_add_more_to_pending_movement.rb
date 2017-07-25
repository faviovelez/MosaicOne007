class AddMoreToPendingMovement < ActiveRecord::Migration
  def change
    add_reference :pending_movements, :business_unit, index: true, foreign_key: true
    add_reference :pending_movements, :prospect, index: true, foreign_key: true
    add_reference :pending_movements, :bill, index: true, foreign_key: true
  end
end
