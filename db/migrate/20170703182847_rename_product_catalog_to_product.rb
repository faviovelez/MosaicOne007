class RenameProductCatalogToProduct < ActiveRecord::Migration
  def change
    rename_table :product_catalogs, :products
  end
end
