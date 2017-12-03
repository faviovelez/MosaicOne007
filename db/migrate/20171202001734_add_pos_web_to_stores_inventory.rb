class AddPosWebToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :pos, :boolean, default: false
    add_column :stores_inventories, :web, :boolean, default: true
    add_column :stores_inventories, :date, :date
  end
end
