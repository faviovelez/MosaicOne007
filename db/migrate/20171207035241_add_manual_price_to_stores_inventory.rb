class AddManualPriceToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :manual_price, :float
  end
end
