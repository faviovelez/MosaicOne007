class AddFieldsToProductSale < ActiveRecord::Migration
  def change
    add_column :product_sales, :total, :float
    add_column :product_sales, :subtotal, :float
    add_column :product_sales, :taxes, :float
    add_column :product_sales, :quantity, :integer
    remove_column :product_sales, :sales_amount
    remove_column :product_sales, :sales_quantity
  end
end
