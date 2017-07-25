class RenameTableWharehouseEntry < ActiveRecord::Migration
  def change
    rename_table :wharehouse_entries, :warehouse_entries
  end
end
