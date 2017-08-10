class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.string :name
      t.references :delivery_address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
