class AddStoreToWarehouseEntry < ActiveRecord::Migration
  def change
    add_reference :warehouse_entries, :store, index: true, foreign_key: true
  end
end
