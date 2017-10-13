class AddManualPriceUpdateToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :manual_price_update, :boolean
  end
end
