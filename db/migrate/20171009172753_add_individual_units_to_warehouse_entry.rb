class AddIndividualUnitsToWarehouseEntry < ActiveRecord::Migration
  def change
    add_column :warehouse_entries, :retail_units_per_unit, :integer
    add_column :warehouse_entries, :units_used, :integer
  end
end
