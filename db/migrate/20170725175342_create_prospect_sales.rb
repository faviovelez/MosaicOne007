class CreateProspectSales < ActiveRecord::Migration
  def change
    create_table :prospect_sales do |t|
      t.references :prospect, index: true, foreign_key: true
      t.string :month
      t.string :year
      t.float :sales_amount
      t.integer :sales_quantity
      t.float :cost

      t.timestamps null: false
    end
  end
end
