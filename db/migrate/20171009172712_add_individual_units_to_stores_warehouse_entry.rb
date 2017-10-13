class AddIndividualUnitsToStoresWarehouseEntry < ActiveRecord::Migration
  def change
    add_column :stores_warehouse_entries, :retail_units_per_unit, :integer
    add_column :stores_warehouse_entries, :units_used, :integer
  end
end
