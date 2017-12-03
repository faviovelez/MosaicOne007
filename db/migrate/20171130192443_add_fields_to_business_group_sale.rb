class AddFieldsToBusinessGroupSale < ActiveRecord::Migration
  def change
    add_column :business_group_sales, :total, :float
    add_column :business_group_sales, :subtotal, :float
    add_column :business_group_sales, :taxes, :float
    remove_column :business_group_sales, :sales_amount
    add_column :business_group_sales, :quantity, :integer
    remove_column :business_group_sales, :sales_quantity
  end
end
