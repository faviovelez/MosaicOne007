class AddPosWebIdsToStoresWarehouseEntry < ActiveRecord::Migration
  def change
    add_column :stores_warehouse_entries, :pos_id, :integer
    add_column :stores_warehouse_entries, :web_id, :integer
  end
end
