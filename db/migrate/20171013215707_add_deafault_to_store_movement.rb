class AddDeafaultToStoreMovement < ActiveRecord::Migration
  def change
    change_column :store_movements, :manual_discount, :float, default: 0
    change_column :store_movements, :automatic_discount, :float, default: 0
    change_column :store_movements, :discount_applied, :float, default: 0
  end
end
