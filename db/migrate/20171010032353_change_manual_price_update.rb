class ChangeManualPriceUpdate < ActiveRecord::Migration
  def change
    change_column :stores_inventories, :manual_price_update, :boolean, default: false
  end
end
