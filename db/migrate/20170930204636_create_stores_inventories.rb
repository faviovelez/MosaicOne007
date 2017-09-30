class CreateStoresInventories < ActiveRecord::Migration
  def change
    create_table :stores_inventories do |t|
      t.references :product, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.integer :quantity
      t.boolean :alert
      t.string :alert_type

      t.timestamps null: false
    end
  end
end
