class RemoveProductCatalogFromImage < ActiveRecord::Migration
  def change
    remove_reference :images, :product_catalog, index: true, foreign_key: true
  end
end
