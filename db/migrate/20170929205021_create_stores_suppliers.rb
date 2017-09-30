class CreateStoresSuppliers < ActiveRecord::Migration
  def change
    create_table :stores_suppliers do |t|
      t.references :store, index: true, foreign_key: true
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
