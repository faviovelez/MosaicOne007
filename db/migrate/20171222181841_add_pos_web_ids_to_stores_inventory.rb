class AddPosWebIdsToStoresInventory < ActiveRecord::Migration
  def change
    add_column :stores_inventories, :pos_id, :integer
    add_column :stores_inventories, :web_id, :integer
  end
end
