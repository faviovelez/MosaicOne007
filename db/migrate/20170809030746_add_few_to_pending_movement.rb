class AddFewToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :discount_applied, :float
    add_column :pending_movements, :final_price, :float
  end
end
