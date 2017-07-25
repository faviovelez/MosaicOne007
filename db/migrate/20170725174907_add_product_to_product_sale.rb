class AddProductToProductSale < ActiveRecord::Migration
  def change
    add_reference :product_sales, :product, index: true, foreign_key: true
  end
end
