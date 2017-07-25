class CreateProductSales < ActiveRecord::Migration
  def change
    create_table :product_sales do |t|
      t.string :month
      t.string :year
      t.float :sales_amount
      t.integer :sales_quantity
      t.float :cost
      t.string :cost_pending

      t.timestamps null: false
    end
  end
end
