class CreateWharehouseEntries < ActiveRecord::Migration
  def change
    create_table :wharehouse_entries do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.float :cost
      t.integer :entry_number
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
