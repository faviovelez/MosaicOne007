class AddCatalogToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :product_catalog, index: true, foreign_key: true
    add_reference :orders, :prospect, index: true, foreign_key: true
  end
end
