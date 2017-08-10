class CreateBusinessGroupSales < ActiveRecord::Migration
  def change
    create_table :business_group_sales do |t|
      t.references :business_group, index: true, foreign_key: true
      t.integer :month
      t.integer :year
      t.float :sales_amount
      t.string :sales_quantity
      t.string :integer
      t.float :cost

      t.timestamps null: false
    end
  end
end
