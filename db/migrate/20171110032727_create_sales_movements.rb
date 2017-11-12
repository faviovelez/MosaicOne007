class CreateSalesMovements < ActiveRecord::Migration
  def change
    create_table :sales_movements do |t|
      t.references :sales, index: true
      t.references :movement, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
