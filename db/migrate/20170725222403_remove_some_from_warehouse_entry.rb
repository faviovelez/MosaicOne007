class RemoveSomeFromWarehouseEntry < ActiveRecord::Migration
  def change
    remove_column :warehouse_entries, :cost, :float
    remove_reference :warehouse_entries, :user, index: true, foreign_key: true
  end
end
