class AddDefaultToStoresWarehouseEntry < ActiveRecord::Migration
  def change
    change_column :stores_warehouse_entries, :quantity, :integer, default: 0
  end
end
