class AddDeafaultToMovement < ActiveRecord::Migration
  def change
    change_column :movements, :manual_discount, :float, default: 0
    change_column :movements, :automatic_discount, :float, default: 0
    change_column :movements, :discount_applied, :float, default: 0
  end
end
