class CreateStoresWarehouseEntries < ActiveRecord::Migration
  def change
    create_table :stores_warehouse_entries do |t|
      t.references :product, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.integer :quantity
      t.references :movement, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
