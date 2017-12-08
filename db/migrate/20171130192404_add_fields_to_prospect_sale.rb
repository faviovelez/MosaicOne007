class AddFieldsToProspectSale < ActiveRecord::Migration
  def change
    add_column :prospect_sales, :total, :float
    add_column :prospect_sales, :subtotal, :float
    add_column :prospect_sales, :taxes, :float
    remove_column :prospect_sales, :sales_amount
    add_column :prospect_sales, :quantity, :integer
    remove_column :prospect_sales, :sales_quantity
  end
end
