class AddSomeToBusinessUnitSale < ActiveRecord::Migration
  def change
    remove_column :business_unit_sales, :month, :string
    remove_column :business_unit_sales, :year, :string
    add_column :business_unit_sales, :month, :integer
    add_column :business_unit_sales, :year, :integer
  end
end
