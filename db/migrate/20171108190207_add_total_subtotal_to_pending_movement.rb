class AddTotalSubtotalToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :total, :float
    add_column :pending_movements, :subtotal, :float
  end
end
