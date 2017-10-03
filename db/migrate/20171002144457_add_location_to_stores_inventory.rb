class AddLocationToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :rack, :string
    add_column :stores_inventories, :level, :string
  end
end
