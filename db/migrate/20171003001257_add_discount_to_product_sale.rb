class AddDiscountToProductSale < ActiveRecord::Migration
  def change
    add_column :product_sales, :discount, :float
  end
end
