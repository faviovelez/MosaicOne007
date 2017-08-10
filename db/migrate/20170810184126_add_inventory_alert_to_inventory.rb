class AddInventoryAlertToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :alert, :boolean
  end
end
