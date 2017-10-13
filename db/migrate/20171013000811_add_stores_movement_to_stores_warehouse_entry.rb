class AddStoresMovementToStoresWarehouseEntry < ActiveRecord::Migration
  def change
    add_reference :stores_warehouse_entries, :store_movement, index: true, foreign_key: true
  end
end
