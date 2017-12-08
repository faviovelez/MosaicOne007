class AddPosWebToStoresWarehouse < ActiveRecord::Migration
  def change
    add_column :stores_warehouse_entries, :pos, :boolean, default: false
    add_column :stores_warehouse_entries, :web, :boolean, default: true
    add_column :stores_warehouse_entries, :date, :date
  end
end
