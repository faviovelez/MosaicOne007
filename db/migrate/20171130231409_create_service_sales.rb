class CreateServiceSales < ActiveRecord::Migration
  def change
    create_table :service_sales do |t|
      t.references :store, index: true, foreign_key: true
      t.integer :year
      t.integer :month
      t.float :cost
      t.float :total
      t.float :subtotal
      t.float :taxes
      t.float :discount
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
