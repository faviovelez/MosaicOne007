class CreateInventoryConfigurations < ActiveRecord::Migration
  def change
    create_table :inventory_configurations do |t|
      t.integer :monts_in_inventory
      t.references :business_unit, index: true, foreign_key: true
      t.float :reorder_point
      t.float :critical_point

      t.timestamps null: false
    end
  end
end
