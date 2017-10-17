class DropInventoryConfigurations < ActiveRecord::Migration
  def change
    drop_table :inventory_configurations
  end
end
