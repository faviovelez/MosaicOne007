class ChangeDefaultToStoresInventory < ActiveRecord::Migration
  def change
    change_column :stores_inventories, :quantity, :integer, default: 0
    change_column :stores_inventories, :alert, :boolean, default: false
  end
end
