class AddDefaultToWarehouseEntry < ActiveRecord::Migration
  def change
    change_column :warehouse_entries, :store_id, :integer, default: 1
  end
end
