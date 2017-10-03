class RemoveErrorsFromBusinessGroupSale < ActiveRecord::Migration
  def change
    remove_column :business_group_sales, :integer, :string
    remove_column :business_group_sales, :sales_quantity, :string
    add_column :business_group_sales, :sales_quantity, :integer

  end
end
