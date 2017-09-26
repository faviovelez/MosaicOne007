class AddDiscountsToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :automatic_discount, :float
    add_column :pending_movements, :manual_discount, :float
    add_reference :pending_movements, :discount_rule, index: true, foreign_key: true
  end
end
