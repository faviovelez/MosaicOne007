class AddDiscountToBusinessUnitSale < ActiveRecord::Migration
  def change
    add_column :business_unit_sales, :discount, :float
  end
end
