class AddReferencesToProductSale < ActiveRecord::Migration
  def change
    add_reference :product_sales, :store, index: true, foreign_key: true
    add_reference :product_sales, :business_unit, index: true, foreign_key: true
  end
end
