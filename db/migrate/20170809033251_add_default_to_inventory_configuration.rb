class AddDefaultToInventoryConfiguration < ActiveRecord::Migration
  def change
    remove_column :inventory_configurations, :monts_in_inventory, :integer
    add_column :inventory_configurations, :months_in_inventory, :integer, :default => 3
    change_column :inventory_configurations, :reorder_point, :float, :default => 0.5
    change_column :inventory_configurations, :critical_point, :float, :default => 0.25
  end
end
