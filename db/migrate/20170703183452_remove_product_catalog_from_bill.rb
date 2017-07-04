class RemoveProductCatalogFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :product_catalog, index: true, foreign_key: true
  end
end
