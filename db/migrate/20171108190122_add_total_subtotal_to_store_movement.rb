class AddTotalSubtotalToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :total, :float
    add_column :store_movements, :subtotal, :float
  end
end
