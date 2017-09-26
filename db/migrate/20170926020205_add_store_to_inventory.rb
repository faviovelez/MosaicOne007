class AddStoreToInventory < ActiveRecord::Migration
  def change
    add_reference :inventories, :store, index: true, foreign_key: true
  end
end
