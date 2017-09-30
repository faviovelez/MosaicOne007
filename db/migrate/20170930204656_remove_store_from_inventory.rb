class RemoveStoreFromInventory < ActiveRecord::Migration
  def change
    remove_reference :inventories, :store, index: true, foreign_key: true
  end
end
