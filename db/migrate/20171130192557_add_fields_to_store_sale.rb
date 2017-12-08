class AddFieldsToStoreSale < ActiveRecord::Migration
  def change
    add_column :store_sales, :total, :float
    add_column :store_sales, :subtotal, :float
    add_column :store_sales, :taxes, :float
    remove_column :store_sales, :sales_amount
    add_column :store_sales, :quantity, :integer
    remove_column :store_sales, :sales_quantity
  end
end
