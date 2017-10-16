class AddDeafaultToPendingMovement < ActiveRecord::Migration
  def change
    change_column :pending_movements, :manual_discount, :float, default: 0
    change_column :pending_movements, :automatic_discount, :float, default: 0
    change_column :pending_movements, :discount_applied, :float, default: 0
  end
end
