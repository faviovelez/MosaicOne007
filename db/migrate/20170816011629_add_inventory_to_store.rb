class AddInventoryToStore < ActiveRecord::Migration
  def change
    add_column :stores, :months_in_inventory, :integer, default: 3
    add_column :stores, :reorder_point, :float, default: 0.5
    add_column :stores, :critical_point, :float, default: 0.25
  end
end
