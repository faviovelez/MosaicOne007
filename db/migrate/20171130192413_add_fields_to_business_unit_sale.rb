class AddFieldsToBusinessUnitSale < ActiveRecord::Migration
  def change
    add_column :business_unit_sales, :total, :float
    add_column :business_unit_sales, :subtotal, :float
    add_column :business_unit_sales, :taxes, :float
    remove_column :business_unit_sales, :sales_amount
    add_column :business_unit_sales, :quantity, :integer
    remove_column :business_unit_sales, :sales_quantity
  end
end
