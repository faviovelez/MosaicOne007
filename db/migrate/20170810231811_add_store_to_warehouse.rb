class AddStoreToWarehouse < ActiveRecord::Migration
  def change
    add_reference :warehouses, :store, index: true, foreign_key: true
  end
end
