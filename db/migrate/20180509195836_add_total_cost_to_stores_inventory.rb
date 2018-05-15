class AddTotalCostToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :total_cost, :float, default: 0
  end
end
