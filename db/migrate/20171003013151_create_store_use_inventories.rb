class CreateStoreUseInventories < ActiveRecord::Migration
  def change
    create_table :store_use_inventories do |t|
      t.references :store, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
