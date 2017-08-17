class AddStoreToInventoryConfiguration < ActiveRecord::Migration
  def change
    add_reference :inventory_configurations, :store, index: true, foreign_key: true
  end
end
