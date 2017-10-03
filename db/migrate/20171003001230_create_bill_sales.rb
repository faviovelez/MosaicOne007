class CreateBillSales < ActiveRecord::Migration
  def change
    create_table :bill_sales do |t|
      t.references :business_unit, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.integer :sales_quantity
      t.float :amount
      t.integer :month
      t.integer :year

      t.timestamps null: false
    end
  end
end
