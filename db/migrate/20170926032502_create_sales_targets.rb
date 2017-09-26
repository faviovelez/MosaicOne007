class CreateSalesTargets < ActiveRecord::Migration
  def change
    create_table :sales_targets do |t|
      t.references :store, index: true, foreign_key: true
      t.integer :month
      t.integer :year
      t.float :target
      t.float :actual_sales
      t.boolean :achieved

      t.timestamps null: false
    end
  end
end
