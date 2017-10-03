class AddDiscountToBillSale < ActiveRecord::Migration
  def change
    add_column :bill_sales, :discount, :float
  end
end
